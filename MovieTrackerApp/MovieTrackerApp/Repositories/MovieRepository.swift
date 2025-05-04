//
//  MovieRepository.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import Foundation
import CoreData
import Combine

protocol MovieRepositoryProtocol {
    // Playlist operations
    func getPlaylists() -> [Playlist]
    func getPlaylist(withName name: String) -> Playlist?
    func createPlaylist(name: String, isDefault: Bool) -> Playlist
    func deletePlaylist(_ playlist: Playlist)
    
    // Movie operations
    func getMovies(inPlaylist playlist: Playlist) -> [Movie]
    func addMovie(_ movieData: MovieResponse, toPlaylist playlist: Playlist) -> Movie
    func removeMovie(_ movie: Movie, fromPlaylist playlist: Playlist)
    func markMovieAsCompleted(_ movie: Movie, isCompleted: Bool)
    func isMovieInPlaylist(_ movieId: String, playlist: Playlist) -> Bool
    
    // Movie fetching from API
    func searchMovies(query: String?, genre: String?, ratingFrom: Double?, year: Int?) -> AnyPublisher<[MovieResponse], Error>
    func getRecommendedMovies(genre: String, userRating: Double) -> AnyPublisher<[MovieResponse], Error>
    func getPopularMovies() -> AnyPublisher<[MovieResponse], Error>
    
    // User stats
    func getUserStats() -> UserStats
    func updateUserStats(movie: Movie)
    func getUserFavoriteGenreAndRating() -> (genre: String, rating: Double)
    
    func getMovie(id: String) -> AnyPublisher<MovieResponse, Error>
    
    // Save context
    func saveContext()
}

class MovieRepository: MovieRepositoryProtocol {
    private let persistenceController: PersistenceController
    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(persistenceController: PersistenceController = .shared,
         apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.persistenceController = persistenceController
        self.apiService = apiService
    }
    
    // MARK: - Core Data Context
    
    private var context: NSManagedObjectContext {
        return persistenceController.container.viewContext
    }
    
    func saveContext() {
        persistenceController.save()
    }
    
    // MARK: - Playlist Operations
    
    func getPlaylists() -> [Playlist] {
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isDefault", ascending: false),
                                   NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching playlists: \(error)")
            return []
        }
    }
    
    func getPlaylist(withName name: String) -> Playlist? {
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching playlist: \(error)")
            return nil
        }
    }
    
    func createPlaylist(name: String, isDefault: Bool = false) -> Playlist {
        let playlist = Playlist(context: context)
        playlist.id = UUID()
        playlist.name = name
        playlist.isDefault = isDefault
        saveContext()
        return playlist
    }
    
    func deletePlaylist(_ playlist: Playlist) {
        // Don't allow deletion of default playlists
        if playlist.isDefault {
            return
        }
        
        context.delete(playlist)
        saveContext()
    }
    
    // MARK: - Movie Operations
    
    func getMovies(inPlaylist playlist: Playlist) -> [Movie] {
        return playlist.moviesArray
    }
    
    func addMovie(_ movieData: MovieResponse, toPlaylist playlist: Playlist) -> Movie {
        // Check if movie already exists in database
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", movieData.id)
        fetchRequest.fetchLimit = 1
        
        var movie: Movie
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingMovie = results.first {
                movie = existingMovie
            } else {
                // Create new movie if it doesn't exist
                movie = Movie(context: context)
                movie.id = movieData.id
                movie.primaryTitle = movieData.primaryTitle
                movie.originalTitle = movieData.originalTitle
                movie.description_text = movieData.description
                movie.primaryImageURL = movieData.primaryImage
                movie.trailerURL = movieData.trailer
                movie.contentRating = movieData.contentRating
                movie.isAdult = movieData.isAdult
                movie.releaseDate = movieData.releaseDate
                movie.startYear = Int32(movieData.startYear)
                if let endYear = movieData.endYear {
                    movie.endYear = Int32(endYear)
                }
                movie.runtimeMinutes = Int32(movieData.runtimeMinutes ?? 0)
                movie.genres = movieData.genres
                movie.interests = movieData.interests
                movie.countriesOfOrigin = movieData.countriesOfOrigin
                movie.spokenLanguages = movieData.spokenLanguages
                movie.averageRating = movieData.averageRating ?? 0.0
                movie.numVotes = Int32(movieData.numVotes ?? 0)
                movie.isCompleted = false
                movie.type = movieData.type
            }
        } catch {
            // Create new movie if fetch fails
            movie = Movie(context: context)
            movie.id = movieData.id
            movie.primaryTitle = movieData.primaryTitle
            movie.originalTitle = movieData.originalTitle
            movie.description_text = movieData.description
            movie.primaryImageURL = movieData.primaryImage
            movie.trailerURL = movieData.trailer
            movie.contentRating = movieData.contentRating
            movie.isAdult = movieData.isAdult
            movie.releaseDate = movieData.releaseDate
            movie.startYear = Int32(movieData.startYear)
            if let endYear = movieData.endYear {
                movie.endYear = Int32(endYear)
            }
            movie.runtimeMinutes = Int32(movieData.runtimeMinutes ?? 0)
            movie.genres = movieData.genres
            movie.interests = movieData.interests
            movie.countriesOfOrigin = movieData.countriesOfOrigin
            movie.spokenLanguages = movieData.spokenLanguages
            movie.averageRating = movieData.averageRating ?? 0.0
            movie.numVotes = Int32(movieData.numVotes ?? 0)
            movie.isCompleted = false
            movie.type = movieData.type
        }
        
        // Add movie to playlist if not already there
        if let playlists = movie.playlists as? Set<Playlist>, !playlists.contains(playlist) {
            movie.addToPlaylists(playlist)
        }
        
        saveContext()
        return movie
    }
    
    func removeMovie(_ movie: Movie, fromPlaylist playlist: Playlist) {
        movie.removeFromPlaylists(playlist)
        
        // If movie is not in any playlist and not completed, delete it
        if movie.playlists?.count == 0 && !movie.isCompleted {
            context.delete(movie)
        }
        
        saveContext()
    }
    
    func markMovieAsCompleted(_ movie: Movie, isCompleted: Bool) {
        let wasCompletedBefore = movie.isCompleted
        movie.isCompleted = isCompleted
        
        // Get the "Completed" playlist
        if let completedPlaylist = getPlaylist(withName: "Completed") {
            if isCompleted {
                // Add to completed playlist if not already there
                if !isMovieInPlaylist(movie.id, playlist: completedPlaylist) {
                    movie.addToPlaylists(completedPlaylist)
                }
                
                // Only update stats if the movie wasn't completed before
                if !wasCompletedBefore {
                    updateUserStats(movie: movie)
                }
            } else {
                // Remove from completed playlist
                if isMovieInPlaylist(movie.id, playlist: completedPlaylist) {
                    movie.removeFromPlaylists(completedPlaylist)
                }
            }
        }
        
        saveContext()
    }
    
    func isMovieInPlaylist(_ movieId: String, playlist: Playlist) -> Bool {
        return playlist.moviesArray.contains { $0.id == movieId }
    }
    
    // MARK: - API Operations
    
    func searchMovies(query: String? = nil, genre: String? = nil, ratingFrom: Double? = nil, year: Int? = nil) -> AnyPublisher<[MovieResponse], Error> {
        return apiService.searchMovies(query: query, genre: genre, ratingFrom: ratingFrom, rows: 20, year: year)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func getRecommendedMovies(genre: String = "Sci-Fi", userRating: Double) -> AnyPublisher<[MovieResponse], Error> {
        return apiService.getRecommendedMovies(genre: genre, userRating: userRating, count: 5)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies() -> AnyPublisher<[MovieResponse], Error> {
        return apiService.getPopularMovies(count: 10)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    // MARK: - User Stats Operations
    
    func getUserStats() -> UserStats {
        let request: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            if let stats = results.first {
                return stats
            } else {
                // Create default stats if none exists
                let stats = UserStats(context: context)
                stats.totalWatchedMovieCount = 0
                stats.totalWatchHours = 0
                stats.averageRating = 0
                stats.genreDistribution = [:]
                saveContext()
                return stats
            }
        } catch {
            print("Error fetching user stats: \(error)")
            // Create default stats if fetch fails
            let stats = UserStats(context: context)
            stats.totalWatchedMovieCount = 0
            stats.totalWatchHours = 0
            stats.averageRating = 0
            stats.genreDistribution = [:]
            saveContext()
            return stats
        }
    }
    
//    func getUserFavoriteGenre() -> String {
//        let stats = getUserStats()
//        let userRating = stats.averageRating;
//        let genreDistribution = stats.genreDistribution ?? [:]
//        
//        // Find the genre with the maximum count
//        if let favoriteGenre = genreDistribution.max(by: { $0.value < $1.value })?.key {
//            return favoriteGenre
//        }
//        
//        return "Drama"
//    }
    
    func getUserFavoriteGenreAndRating() -> (genre: String, rating: Double) {
        let stats = getUserStats()
        let userRating = stats.averageRating
        let genreDistribution = stats.genreDistribution ?? [:]

        let favoriteGenre = genreDistribution.max(by: { $0.value < $1.value })?.key ?? "Sci-Fi"
        let rating = (userRating > 0) ? userRating : 5.0

        return (genre: favoriteGenre, rating: rating)
    }
    
    func updateUserStats(movie: Movie) {
        let stats = getUserStats()
        
        // Update movie count
        stats.totalWatchedMovieCount += 1
        
        // Update watch hours
        stats.totalWatchHours += Double(movie.runtimeMinutes) / 60.0
        
        // Update average rating
        let totalRating = stats.averageRating * Double(stats.totalWatchedMovieCount - 1)
        stats.averageRating = (totalRating + movie.averageRating) / Double(stats.totalWatchedMovieCount)
        
        // Update genre distribution
        var genreDistribution = stats.genreDistribution ?? [:]
        
        if let genres = movie.genres {
            for genre in genres {
                let currentCount = genreDistribution[genre] ?? 0
                genreDistribution[genre] = currentCount + 1
            }
        }
        
        stats.genreDistribution = genreDistribution
        
        // Update favorite genre
        if let favoriteGenre = genreDistribution.max(by: { $0.value < $1.value })?.key {
            stats.favoriteGenre = favoriteGenre
        }
        
        saveContext()
    }
    
    
    func getMovie(id: String) -> AnyPublisher<MovieResponse, Error> {
        // First check if we have this movie in Core Data
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingMovie = results.first {
                // Convert Core Data Movie to MovieResponse
                let movieResponse = convertCoreDataMovieToResponse(existingMovie)
                return Just(movieResponse)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        } catch {
            print("Error fetching movie from Core Data: \(error)")
        }
        
        // If not found in Core Data, fetch from API
        return apiService.getMovie(id: id)
            .eraseToAnyPublisher()
    }

    private func convertCoreDataMovieToResponse(_ movie: Movie) -> MovieResponse {
        return MovieResponse(
            id: movie.id,
            url: nil,
            primaryTitle: movie.primaryTitle,
            originalTitle: movie.originalTitle,
            type: movie.type,
            description: movie.description_text,
            primaryImage: movie.primaryImageURL,
            trailer: movie.trailerURL,
            contentRating: movie.contentRating,
            isAdult: movie.isAdult,
            releaseDate: movie.releaseDate,
            startYear: Int(movie.startYear),
            endYear: movie.endYear != nil ? Int(movie.endYear) : nil, //
            runtimeMinutes: Int(movie.runtimeMinutes),
            genres: movie.genres,
            interests: movie.interests,
            countriesOfOrigin: movie.countriesOfOrigin,
            spokenLanguages: movie.spokenLanguages,
            averageRating: movie.averageRating,
            numVotes: Int(movie.numVotes)
        )
    }
}
