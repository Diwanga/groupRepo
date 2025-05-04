//
//  MyCinemaViewModel.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//


import Foundation
import CoreData

class MyCinemaViewModel: ObservableObject {
    @Published var playlists: [PlayList] = []
    @Published var recommendedMovies: [MovieData] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
        loadPlaylists()
        fetchRecommendedMovies()
    }
    
    func loadPlaylists() {
        playlists = repository.fetchPlayLists()
    }
    
    func fetchRecommendedMovies() {
        isLoading = true
        repository.fetchMovies(searchQuery: "breaking", genre: nil, minRating: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.recommendedMovies = movies
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
