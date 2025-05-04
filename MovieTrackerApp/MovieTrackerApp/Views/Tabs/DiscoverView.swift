//
//  DiscoverView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI

// MARK: - Discover Tab

struct DiscoverView: View {
    @ObservedObject var viewModel: DiscoverViewModel
    @State private var showingSearchFilters = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    SearchBar(searchText: $viewModel.searchText) {
                        viewModel.searchMovies()
                    }
                    
                    Button(action: {
                        showingSearchFilters = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Filter chips (if any active)
                if viewModel.selectedGenre != nil || viewModel.minRating > 0 || viewModel.yearFrom != nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            if let genre = viewModel.selectedGenre {
                                FilterChip(label: "Genre: \(genre)") {
                                    viewModel.selectedGenre = nil
                                    viewModel.searchMovies()
                                }
                            }
                            
                            if viewModel.minRating > 0 {
                                FilterChip(label: String(format: "Rating: %.1f+", viewModel.minRating)) {
                                    viewModel.minRating = 0
                                    viewModel.searchMovies()
                                }
                            }
                            
                            if let year = viewModel.yearFrom {
                                FilterChip(label: "Year: \(year)+") {
                                    viewModel.yearFrom = nil
                                    viewModel.searchMovies()
                                }
                            }
                            
                            Button(action: {
                                viewModel.clearSearch()
                            }) {
                                Text("Clear All")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.accentColor.opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // Movies grid
                if viewModel.isLoading {
                    LoadingView(message: "Searching for movies...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.searchMovies()
                    }
                } else if viewModel.movies.isEmpty {
                    EmptyStateView(
                        title: "No movies found",
                        message: "Try adjusting your search criteria",
                        systemImage: "film"
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                    MovieTile(movie: movie)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Discover")
            .sheet(isPresented: $showingSearchFilters) {
                MovieSearchFiltersView(
                    genre: $viewModel.selectedGenre,
                    minRating: $viewModel.minRating,
                    yearFrom: $viewModel.yearFrom,
                    availableGenres: viewModel.availableGenres,
                    isPresented: $showingSearchFilters
                ) {
                    viewModel.searchMovies()
                }
            }
        }
    }
}
