//
//  MyCinemaViewModel.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import Foundation
import Combine
import SwiftUI
import CoreData


// MARK: - My Cinema Tab ViewModel
class MyCinemaViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var selectedPlaylist: Playlist?
    @Published var moviesInSelectedPlaylist: [MovieItemViewModel] = []
    @Published var recommendedMovies: [MovieItemViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
        loadPlaylists()
        loadRecommendedMovies()
    }
    
    func loadPlaylists() {
        playlists = repository.getPlaylists()
        
        // Select first playlist by default if available
        if selectedPlaylist == nil, let firstPlaylist = playlists.first {
            selectPlaylist(firstPlaylist)
        }
    }
    
    func selectPlaylist(_ playlist: Playlist) {
        selectedPlaylist = playlist
        loadMoviesInSelectedPlaylist()
        
        // Load recommendations based on completed movies genres
        
    }
    
    func loadMoviesInSelectedPlaylist() {
        guard let playlist = selectedPlaylist else { return }
        
        let movies = repository.getMovies(inPlaylist: playlist)
        moviesInSelectedPlaylist = movies.map { MovieItemViewModel(movie: $0) }
    }
    
    func loadRecommendedMovies() {
        isLoading = true
        errorMessage = nil
        
        // Get most common genre from completed movies
      //  var targetGenre = "Drama" // Default genre
        
//        if let completedPlaylist = repository.getPlaylist(withName: "Completed"),
//           !completedPlaylist.moviesArray.isEmpty {
//            let movies = completedPlaylist.moviesArray
//            
//            // Count genres
//            var genreCounts: [String: Int] = [:]
//            for movie in movies {
//                if let genres = movie.genres {
//                    for genre in genres {
//                        genreCounts[genre, default: 0] += 1
//                    }
//                }
//            }
//            
//            // Find most common genre
//            if let mostCommonGenre = genreCounts.max(by: { $0.value < $1.value })?.key {
//                targetGenre = mostCommonGenre
//            }
//        }
        let result = repository.getUserFavoriteGenreAndRating()
        let targetGenre = result.genre
        let targetRating = result.rating
        
        repository.getRecommendedMovies(genre: targetGenre, userRating: targetRating)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.recommendedMovies = movies.map { MovieItemViewModel(movie: $0) }
            }
            .store(in: &cancellables)
    }
    
    func createPlaylist(name: String) {
        let newPlaylist = repository.createPlaylist(name: name, isDefault: false)
        loadPlaylists()
        // Select the newly created playlist
        selectPlaylist(newPlaylist)
    }
    
    func deletePlaylist(_ playlist: Playlist) {
        repository.deletePlaylist(playlist)
        loadPlaylists()
    }
    
    func isMovieInPlaylist(_ movieId: String, playlistName: String) -> Bool {
        guard let playlist = repository.getPlaylist(withName: playlistName) else {
            return false
        }
        
        return repository.isMovieInPlaylist(movieId, playlist: playlist)
    }
    
    func refresh() {
        loadPlaylists()
    }
}
