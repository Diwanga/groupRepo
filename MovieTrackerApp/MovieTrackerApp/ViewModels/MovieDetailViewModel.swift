//
//  MovieDetailViewModel.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import Foundation
import Combine
import SwiftUI
import CoreData


//class MovieDetailViewModel: ObservableObject {
//    @Published var movie: MovieResponse?
//    @Published var isCompleted: Bool = false
//    @Published var isInWatchlist: Bool = false
//    @Published var userPlaylists: [Playlist] = []
//    @Published var selectedPlaylists: Set<UUID> = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    
//    private let movieId: String
//    private let repository: MovieRepositoryProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(movieId: String, repository: MovieRepositoryProtocol = MovieRepository()) {
//        self.movieId = movieId
//        self.repository = repository
//        loadPlaylists()
//        checkMovieStatus()
//    }
class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieResponse?
    @Published var isCompleted: Bool = false
    @Published var isInWatchlist: Bool = false
    @Published var userPlaylists: [Playlist] = []
    @Published var selectedPlaylists: Set<UUID> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let movieId: String
    private let repository: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: String, repository: MovieRepositoryProtocol = MovieRepository()) {
        print("MovieDetailViewModel init with ID: \(movieId)")
        self.movieId = movieId
        self.repository = repository
        
        // Load movie details first, then check status
        loadMovieDetails()
    }
    
    func loadMovieDetails() {
        print("Loading movie details for ID: \(movieId)")
        isLoading = true
        errorMessage = nil
        
        repository.getMovie(id: movieId)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error loading movie: \(error)")
                }
            } receiveValue: { [weak self] movie in
                print("Successfully loaded movie: \(movie.primaryTitle)")
                self?.movie = movie
                
                // Now that we have the movie data, check the playlist status
                self?.loadPlaylists()
                self?.checkMovieStatus()
            }
            .store(in: &cancellables)
    }
    
    func loadPlaylists() {
        userPlaylists = repository.getPlaylists().filter { !$0.isDefault }
        
        // Check if movie is in any of the playlists
        for playlist in userPlaylists {
            if repository.isMovieInPlaylist(movieId, playlist: playlist) {
                selectedPlaylists.insert(playlist.id)
            }
        }
    }
    
    func checkMovieStatus() {
        // Check if movie is in completed playlist
        if let completedPlaylist = repository.getPlaylist(withName: "Completed") {
            isCompleted = repository.isMovieInPlaylist(movieId, playlist: completedPlaylist)
        }
        
        // Check if movie is in watchlist
        if let watchlistPlaylist = repository.getPlaylist(withName: "Watch List") {
            isInWatchlist = repository.isMovieInPlaylist(movieId, playlist: watchlistPlaylist)
        }
    }
    
    func toggleCompleted() {
        guard let movie = movie else { return }
        
        // Convert API movie to CoreData movie
        let movieData = movie
        let completedPlaylist = repository.getPlaylist(withName: "Completed")!
        
        let coreDataMovie = repository.addMovie(movieData, toPlaylist: completedPlaylist)
        repository.markMovieAsCompleted(coreDataMovie, isCompleted: !isCompleted)
        
        // Update UI state
        isCompleted.toggle()
        checkMovieStatus()
    }
    
    func toggleWatchlist() {
        guard let movie = movie else { return }
        
        let watchlistPlaylist = repository.getPlaylist(withName: "Watch List")!
        
        if isInWatchlist {
            // Find the movie in the database and remove it
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", movie.id)
            
            do {
                let context = PersistenceController.shared.container.viewContext
                let results = try context.fetch(fetchRequest)
                
                if let coreDataMovie = results.first {
                    repository.removeMovie(coreDataMovie, fromPlaylist: watchlistPlaylist)
                }
            } catch {
                print("Error fetching movie: \(error)")
            }
        } else {
            // Add movie to watchlist
            _ = repository.addMovie(movie, toPlaylist: watchlistPlaylist)
        }
        
        // Update UI state
        isInWatchlist.toggle()
    }
    
    func updatePlaylistSelections() {
        guard let movie = movie else { return }
        
        // Convert API movie to CoreData movie if needed
        let movieData = movie
        
        // Add/remove movie from selected playlists
        for playlist in userPlaylists {
            let isSelected = selectedPlaylists.contains(playlist.id)
            let isInPlaylist = repository.isMovieInPlaylist(movieId, playlist: playlist)
            
            if isSelected && !isInPlaylist {
                // Add to playlist
                _ = repository.addMovie(movieData, toPlaylist: playlist)
            } else if !isSelected && isInPlaylist {
                // Remove from playlist
                let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", movie.id)
                
                do {
                    let context = PersistenceController.shared.container.viewContext
                    let results = try context.fetch(fetchRequest)
                    
                    if let coreDataMovie = results.first {
                        repository.removeMovie(coreDataMovie, fromPlaylist: playlist)
                    }
                } catch {
                    print("Error fetching movie: \(error)")
                }
            }
        }
    }
    
    func togglePlaylist(_ playlist: Playlist) {
        if selectedPlaylists.contains(playlist.id) {
            selectedPlaylists.remove(playlist.id)
        } else {
            selectedPlaylists.insert(playlist.id)
        }
        
        updatePlaylistSelections()
    }
    
    // Add this method to your MovieDetailViewModel
    func togglePlaylistSelections() {
        guard let movie = movie else { return }
        
        for playlist in userPlaylists {
            let isSelected = selectedPlaylists.contains(playlist.id)
            let isInPlaylist = repository.isMovieInPlaylist(movieId, playlist: playlist)
            
            if isSelected && !isInPlaylist {
                // Add to playlist
                _ = repository.addMovie(movie, toPlaylist: playlist)
            } else if !isSelected && isInPlaylist {
                // Remove from playlist
                let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", movie.id)
                
                do {
                    let context = PersistenceController.shared.container.viewContext
                    let results = try context.fetch(fetchRequest)
                    
                    if let coreDataMovie = results.first {
                        repository.removeMovie(coreDataMovie, fromPlaylist: playlist)
                    }
                } catch {
                    print("Error fetching movie: \(error)")
                }
            }
        }
    }
}






