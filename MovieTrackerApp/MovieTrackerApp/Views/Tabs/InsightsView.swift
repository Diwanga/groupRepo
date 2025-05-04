//
//  InsightsView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI

// MARK: - Insights Tab

struct InsightsView: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Movies Watched",
                            value: "\(viewModel.totalMoviesWatched)",
                            systemImage: "film"
                        )
                        
                        StatCard(
                            title: "Favorite Genre",
                            value: viewModel.favoriteGenre,
                            systemImage: "star"
                        )
                        
                        StatCard(
                            title: "Watch Hours",
                            value: String(format: "%.1f", viewModel.totalWatchHours),
                            systemImage: "clock"
                        )
                        
                        StatCard(
                            title: "Avg Rating",
                            value: String(format: "%.1f", viewModel.averageRating),
                            systemImage: "star.fill"
                        )
                    }
                    
                    // Genre chart
                    GenreDistributionChart(data: viewModel.genreDistribution)
                }
                .padding()
            }
            .navigationTitle("Insights")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.loadUserStats()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}
