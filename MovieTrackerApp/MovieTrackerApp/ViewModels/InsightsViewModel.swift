//
//  InsightsViewModel.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import Foundation
import Combine
import SwiftUI
import CoreData



// MARK: - Insights Tab ViewModel
class InsightsViewModel: ObservableObject {
    @Published var totalMoviesWatched: Int = 0
    @Published var totalWatchHours: Double = 0
    @Published var favoriteGenre: String = "N/A"
    @Published var averageRating: Double = 0.0
    @Published var genreDistribution: [String: Int] = [:]
    
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
        loadUserStats()
    }
    
    func loadUserStats() {
        let stats = repository.getUserStats()
        
        totalMoviesWatched = Int(stats.totalWatchedMovieCount)
        totalWatchHours = stats.totalWatchHours
        favoriteGenre = stats.favoriteGenre ?? "N/A"
        averageRating = stats.averageRating
        genreDistribution = stats.genreDistribution ?? [:]
    }
}
