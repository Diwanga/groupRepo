////
////  CoreDataManager.swift
////  MovieTracker
////
////  Created by Diwanga Amasith on 2025-05-02.
////
//
//import Foundation
//import CoreData
//
//class CoreDataManager {
//    static let shared = CoreDataManager()
//    
//    private init() {}
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "MovieTrackerModel")
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        // Create default playlists if needed
//        DispatchQueue.main.async {
//            self.createDefaultPlayLists()
//        }
//        return container
//    }()
//    
//    var context: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//    
//    func saveContext() {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//    // MARK: - PlayList Operations
//    func createDefaultPlayLists() {
//        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "isDefault == true")
//        
//        do {
//            let existingLists = try context.fetch(fetchRequest)
//            if existingLists.isEmpty {
//                let watchlist = PlayList(context: context)
//                watchlist.id = UUID()
//                watchlist.name = "Watchlist"
//                watchlist.isDefault = true
//                
//                let completed = PlayList(context: context)
//                completed.id = UUID()
//                completed.name = "Completed"
//                completed.isDefault = true
//                
//                saveContext()
//            }
//        } catch {
//            print("Error creating default playlists: \(error)")
//        }
//    }
//    
//    func fetchPlayLists() -> [PlayList] {
//        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
//        
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            print("Error fetching playlists: \(error)")
//            return []
//        }
//    }
//    
//    // MARK: - Movie Operations
//    func saveMovie(from movieData: MovieData, to playlist: PlayList? = nil) -> Movie {
//        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", movieData.id)
//        
//        let movie: Movie
//        
//        if let existingMovie = try? context.fetch(fetchRequest).first {
//            movie = existingMovie
//        } else {
//            movie = Movie(context: context)
//            movie.id = movieData.id
//            movie.primaryTitle = movieData.primaryTitle
//            movie.originalTitle = movieData.originalTitle
//            movie.type = movieData.type
////            movie.movieDescription = movieData.description
//            movie.primaryImage = movieData.primaryImage
//            movie.trailer = movieData.trailer
//            movie.contentRating = movieData.contentRating
//            movie.isAdult = movieData.isAdult
//            movie.releaseDate = movieData.releaseDate
////            movie.runtimeMinutes = Int16(movieData.runtimeMinutes ?? 0)
//            movie.genres = movieData.genres as? NSObject
//            movie.averageRating = movieData.averageRating ?? 0
////            movie.numVotes = Int32(movieData.numVotes ?? 0)
//        }
//        
//        if let playlist = playlist {
//            movie.addToWatchlist(playlist)
//        }
//        
//        saveContext()
//        return movie
//    }
//    
//    func fetchMovies(for playlist: PlayList) -> [Movie] {
//        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "ANY watchlist == %@", playlist)
//        
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            print("Error fetching movies for playlist: \(error)")
//            return []
//        }
//    }
//    
//    func markMovieAsCompleted(_ movie: Movie) {
//        movie.isCompleted = true
//        movie.completedDate = Date()
//        
//        // Add to Completed playlist if not already
//        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
//        
//        if let completedList = try? context.fetch(fetchRequest).first {
//            movie.addToWatchlist(completedList)
//        }
//        
//        updateUserStats()
//        saveContext()
//    }
//    
//    func removeMovieFromWatchlist(_ movie: Movie, playlist: PlayList) {
//        movie.removeFromWatchlist(playlist)
//        saveContext()
//    }
//    
//    // MARK: - User Stats Operations
//    func updateUserStats() {
//        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
//        
//        guard let completedList = try? context.fetch(fetchRequest).first else { return }
//        
//        let movies = fetchMovies(for: completedList)
//        let completedMovies = movies.filter { $0.isCompleted }
//        
//        let totalMovies = Int32(completedMovies.count)
//        let totalHours = 10 //completedMovies.reduce(0.0) { $0 + Double($1.runtimeMinutes) / 60.0 }
//        let averageRating = completedMovies.isEmpty ? 0.0 : completedMovies.reduce(0.0) { $0 + $1.averageRating } / Double(completedMovies.count)
//        
//        // Calculate favorite genre
//        var genreCounts: [String: Int] = [:]
//        for movie in completedMovies {
//            if let genres = movie.genres as? [String] {
//                for genre in genres {
//                    genreCounts[genre] = (genreCounts[genre] ?? 0) + 1
//                }
//            }
//        }
//        
//        let favoriteGenre = genreCounts.max { $0.value < $1.value }?.key ?? "None"
//        
//        let statsFetchRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
//        let userStats: UserStats
//        
//        if let existingStats = try? context.fetch(statsFetchRequest).first {
//            userStats = existingStats
//        } else {
//            userStats = UserStats(context: context)
//        }
//        
//        userStats.totalWatchedMovies = totalMovies
//        userStats.totalWatchHours = Int32(totalHours)
//        userStats.averageRating = averageRating
//        userStats.favoriteGenre = favoriteGenre
//        
//        saveContext()
//    }
//    
//    func fetchUserStats() -> UserStats? {
//        let fetchRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
//        
//        do {
//            return try context.fetch(fetchRequest).first
//        } catch {
//            print("Error fetching user stats: \(error)")
//            return nil
//        }
//    }
//}

//
//  CoreDataManager.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieTracker")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - PlayList Operations
    func createDefaultPlayLists() {
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDefault == true")
        
        do {
            let existingLists = try context.fetch(fetchRequest)
            if existingLists.isEmpty {
                let watchlist = PlayList(context: context)
                watchlist.id = UUID()
                watchlist.name = "Watchlist"
                watchlist.isDefault = true
                
                let completed = PlayList(context: context)
                completed.id = UUID()
                completed.name = "Completed"
                completed.isDefault = true
                
                saveContext()
                print("Created default playlists")
            }
        } catch {
            print("Error creating default playlists: \(error)")
        }
    }
    
    func fetchPlayLists() -> [PlayList] {
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        
        do {
            let playlists = try context.fetch(fetchRequest)
            
            // If no playlists exist, create them
            if playlists.isEmpty {
                print("No playlists found, creating defaults")
                createDefaultPlayLists()
                return try context.fetch(fetchRequest)
            }
            
            return playlists
        } catch {
            print("Error fetching playlists: \(error)")
            return []
        }
    }
    
    // MARK: - Movie Operations
    func saveMovie(from movieData: MovieData, to playlist: PlayList? = nil) -> Movie {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", movieData.id)
        
        let movie: Movie
        
        do {
            if let existingMovie = try context.fetch(fetchRequest).first {
                movie = existingMovie
            } else {
                movie = Movie(context: context)
                movie.id = movieData.id
                movie.primaryTitle = movieData.primaryTitle
                movie.originalTitle = movieData.originalTitle
                movie.type = movieData.type
                movie.primaryImage = movieData.primaryImage
                movie.trailer = movieData.trailer
                movie.contentRating = movieData.contentRating
                movie.isAdult = movieData.isAdult
                
                // Handle optional properties safely
                if let genres = movieData.genres {
                    movie.genres = genres as NSObject
                }
                movie.averageRating = movieData.averageRating ?? 0
            }
            
            if let playlist = playlist {
                // Check if movie is already in playlist
                let playlistMovies = fetchMovies(for: playlist)
                if !playlistMovies.contains(where: { $0.id == movie.id }) {
                    movie.addToWatchlist(playlist)
                }
            }
            
            saveContext()
            return movie
        } catch {
            print("Error saving movie: \(error)")
            
            // Create new movie as fallback
            let newMovie = Movie(context: context)
            newMovie.id = movieData.id
            newMovie.primaryTitle = movieData.primaryTitle
            
            if let playlist = playlist {
                newMovie.addToWatchlist(playlist)
            }
            
            saveContext()
            return newMovie
        }
    }
    
    func fetchMovies(for playlist: PlayList) -> [Movie] {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY watchlist == %@", playlist)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching movies for playlist: \(error)")
            return []
        }
    }
    
    func markMovieAsCompleted(_ movie: Movie) {
        movie.isCompleted = true
        movie.completedDate = Date()
        
        // Add to Completed playlist if not already
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
        
        do {
            if let completedList = try context.fetch(fetchRequest).first {
                // Check if movie is already in this playlist
                let completedMovies = fetchMovies(for: completedList)
                if !completedMovies.contains(where: { $0.id == movie.id }) {
                    movie.addToWatchlist(completedList)
                }
            }
            
            updateUserStats()
            saveContext()
        } catch {
            print("Error marking movie as completed: \(error)")
        }
    }
    
    func removeMovieFromWatchlist(_ movie: Movie, playlist: PlayList) {
        movie.removeFromWatchlist(playlist)
        saveContext()
    }
    
    // MARK: - User Stats Operations
    func updateUserStats() {
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
        
        do {
            guard let completedList = try context.fetch(fetchRequest).first else { return }
            
            let movies = fetchMovies(for: completedList)
            let completedMovies = movies.filter { $0.isCompleted }
            
            let totalMovies = Int32(completedMovies.count)
            // Since we don't have runtimeMinutes, we'll estimate 2 hours per movie
            let totalHours = Int32(completedMovies.count * 2)
            
            // Calculate average rating
            let totalRating = completedMovies.reduce(0.0) { $0 + $1.averageRating }
            let averageRating = completedMovies.isEmpty ? 0.0 : totalRating / Double(completedMovies.count)
            
            // Calculate favorite genre
            var genreCounts: [String: Int] = [:]
            for movie in completedMovies {
                if let genres = movie.genres as? [String] {
                    for genre in genres {
                        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1
                    }
                }
            }
            
            let favoriteGenre = genreCounts.max { $0.value < $1.value }?.key ?? "None"
            
            // Save to UserStats
            let statsFetchRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
            let userStats: UserStats
            
            if let existingStats = try context.fetch(statsFetchRequest).first {
                userStats = existingStats
            } else {
                userStats = UserStats(context: context)
            }
            
            userStats.totalWatchedMovies = totalMovies
            userStats.totalWatchHours = totalHours
            userStats.averageRating = averageRating
            userStats.favoriteGenre = favoriteGenre
            
            saveContext()
        } catch {
            print("Error updating user stats: \(error)")
        }
    }
    
    func fetchUserStats() -> UserStats? {
        let fetchRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching user stats: \(error)")
            return nil
        }
    }
}
