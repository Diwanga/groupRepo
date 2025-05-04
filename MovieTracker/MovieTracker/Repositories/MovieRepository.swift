////
////  MovieRepository.swift
////  MovieTracker
////
////  Created by Diwanga Amasith on 2025-05-02.
////

import Foundation
import CoreData

protocol MovieRepositoryProtocol {
    func fetchMovies(searchQuery: String?, genre: String?, minRating: Double?, completion: @escaping (Result<[MovieData], Error>) -> Void)
    func saveMovie(_ movieData: MovieData, to playlist: PlayList?) -> Movie
    func fetchPlayLists() -> [PlayList]
    func fetchMovies(for playlist: PlayList) -> [Movie]
    func markMovieAsCompleted(_ movie: Movie)
    func removeMovieFromWatchlist(_ movie: Movie, playlist: PlayList)
    func fetchUserStats() -> UserStats?
}

class MovieRepository: MovieRepositoryProtocol, ObservableObject {
    private let apiClient: APIClientProtocol
    private let coreDataManager: CoreDataManager
    
    init(apiClient: APIClientProtocol = APIClient.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
        self.coreDataManager.createDefaultPlayLists()
    }
    
    func fetchMovies(searchQuery: String?, genre: String?, minRating: Double?, completion: @escaping (Result<[MovieData], Error>) -> Void) {
        apiClient.fetchMovies(searchQuery: searchQuery, genre: genre, minRating: minRating) { result in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveMovie(_ movieData: MovieData, to playlist: PlayList?) -> Movie {
        return coreDataManager.saveMovie(from: movieData, to: playlist)
    }
    
    func fetchPlayLists() -> [PlayList] {
        return coreDataManager.fetchPlayLists()
    }
    
    func fetchMovies(for playlist: PlayList) -> [Movie] {
        return coreDataManager.fetchMovies(for: playlist)
    }
    
    func markMovieAsCompleted(_ movie: Movie) {
        coreDataManager.markMovieAsCompleted(movie)
    }
    
    func removeMovieFromWatchlist(_ movie: Movie, playlist: PlayList) {
        coreDataManager.removeMovieFromWatchlist(movie, playlist: playlist)
    }
    
    func fetchUserStats() -> UserStats? {
        return coreDataManager.fetchUserStats()
    }
}
