import SwiftUI
import Charts
import Foundation

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let stats = viewModel.userStats {
                    // Stats Overview
                    HStack(spacing: 15) {
                        StatCard(value: "\(stats.totalWatchedMovies)", label: "Movies", icon: "film")
                        StatCard(value: String(format: "%.1f", stats.totalWatchHours), label: "Hours", icon: "clock")
                        StatCard(value: String(format: "%.1f", stats.averageRating), label: "Avg Rating", icon: "star")
                        StatCard(value: stats.favoriteGenre ?? "None", label: "Top Genre", icon: "heart")
                    }
                    .padding(.horizontal)
                    
                    // Genre Distribution Chart
                    VStack(alignment: .leading) {
                        Text("Genre Distribution")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(viewModel.genreDistribution.sorted(by: { $0.value > $1.value }), id: \.key) { genre, count in
                                BarMark(
                                    x: .value("Genre", genre),
                                    y: .value("Count", count)
                                )
                                .foregroundStyle(by: .value("Genre", genre))
                            }
                        }
                        .chartLegend(.hidden)
                        .frame(height: 200)
                        .padding()
                    }
                    
                    // Rating Distribution
                    VStack(alignment: .leading) {
                        Text("Rating Distribution")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // This would require additional data in CoreData
                        // For now, we'll just show a placeholder
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                            .overlay(
                                Text("Rating distribution chart would go here")
                                    .foregroundColor(.secondary)
                            )
                            .padding(.horizontal)
                    }
                } else {
                    Text("No insights available yet. Watch some movies first!")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Insights")
        .onAppear {
            viewModel.loadUserStats()
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
