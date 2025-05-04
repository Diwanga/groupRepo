//
//  MovieListViewModel.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

import Foundation
import CoreData

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: MovieRepositoryProtocol
    let playlist: PlayList?
    
    init(repository: MovieRepositoryProtocol = MovieRepository(), playlist: PlayList? = nil) {
        self.repository = repository
        self.playlist = playlist
        if let playlist = playlist {
            loadMovies(for: playlist)
        }
    }
    
    func loadMovies(for playlist: PlayList) {
        movies = repository.fetchMovies(for: playlist)
    }
    
    func removeMovie(_ movie: Movie) {
        if let playlist = playlist {
            repository.removeMovieFromWatchlist(movie, playlist: playlist)
            loadMovies(for: playlist)
        }
    }
    
    func markAsCompleted(_ movie: Movie) {
        repository.markMovieAsCompleted(movie)
        if let playlist = playlist {
            loadMovies(for: playlist)
        }
    }
}
