//
//  DiscoverViewModel.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import Foundation
import Combine
import SwiftUI
import CoreData


// MARK: - Discover Tab ViewModel
class DiscoverViewModel: ObservableObject {
    @Published var movies: [MovieItemViewModel] = []
    @Published var searchText: String = ""
    @Published var selectedGenre: String?
    @Published var minRating: Double = 0.0
    @Published var yearFrom: Int?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let availableGenres = ["Action", "Adventure", "Animation", "Biography", "Comedy", "Crime",
                          "Documentary", "Drama", "Family", "Fantasy", "History", "Horror",
                          "Music", "Musical", "Mystery", "Romance", "Sci-Fi", "Sport",
                          "Thriller", "War", "Western"]
    
    private let repository: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
        loadPopularMovies()
    }
    
    func loadPopularMovies() {
        isLoading = true
        errorMessage = nil
        
        repository.getPopularMovies()
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies.map { MovieItemViewModel(movie: $0) }
            }
            .store(in: &cancellables)
    }
    
    func searchMovies() {
        isLoading = true
        errorMessage = nil
        
        // Don't search if all criteria are empty
        if searchText.isEmpty && selectedGenre == nil && minRating == 0 && yearFrom == nil {
            loadPopularMovies()
            return
        }
        
        let query = searchText.isEmpty ? nil : searchText
        let genre = selectedGenre
        let rating = minRating > 0 ? minRating : nil
        let year = yearFrom
        
        repository.searchMovies(query: query, genre: genre, ratingFrom: rating, year: year)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies.map { MovieItemViewModel(movie: $0) }
            }
            .store(in: &cancellables)
    }
    
    func clearSearch() {
        searchText = ""
        selectedGenre = nil
        minRating = 0.0
        yearFrom = nil
        loadPopularMovies()
    }
}
