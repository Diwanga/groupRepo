//
//  MovieDetailView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI


// MARK: - Movie Detail View

struct MovieDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: MovieDetailViewModel
    @State private var showingPlaylistSelector = false
    
    init(movieId: String) {
        self._viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Banner image
                if let movie = viewModel.movie, let imageURLString = movie.primaryImage, let imageURL = URL(string: imageURLString) {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        } else if phase.error != nil {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .overlay(
                                    Image(systemName: "film")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                )
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .overlay(ProgressView())
                        }
                    }
                } else {
                   // Text("NO IMAGE")
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "film")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        )
                }
                
                if let movie = viewModel.movie {
                    // Title and year
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.primaryTitle)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("\(movie.startYear)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if let runtime = movie.runtimeMinutes, runtime > 0 {
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text("\(runtime) min")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let rating = movie.averageRating, rating > 0 {
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.subheadline)
                                    
                                    Text(String(format: "%.1f", rating))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        if let genres = movie.genres, !genres.isEmpty {
                            HStack {
                                ForEach(genres, id: \.self) { genre in
                                    Text(genre)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        // Completed button
                        Button(action: {
                            viewModel.toggleCompleted()
                        }) {
                            VStack {
                                Image(systemName: viewModel.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                                    .font(.title2)
                                
                                Text("Completed")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(viewModel.isCompleted ? .green : .primary)
                        
                        // Watchlist button
                        Button(action: {
                            viewModel.toggleWatchlist()
                        }) {
                            VStack {
                                Image(systemName: viewModel.isInWatchlist ? "bookmark.fill" : "bookmark")
                                    .font(.title2)
                                
                                Text("Watchlist")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(viewModel.isInWatchlist ? .blue : .primary)
                        
                        // Add to playlist button
                        Button(action: {
                            showingPlaylistSelector = true
                        }) {
                            VStack {
                                Image(systemName: "plus.rectangle.on.folder")
                                    .font(.title2)
                                
                                Text("Add to list")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 24)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.headline)
                        
                        if let description = movie.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        } else {
                            Text("No overview available.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Additional info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Details")
                            .font(.headline)
                            .padding(.top)
                        
                        detailRow(label: "Release Date", value: movie.releaseDate ?? "Unknown")
                        
                        if let languages = movie.spokenLanguages, !languages.isEmpty {
                            detailRow(label: "Languages", value: languages.joined(separator: ", "))
                        }
                        
                        if let countries = movie.countriesOfOrigin, !countries.isEmpty {
                            detailRow(label: "Countries", value: countries.joined(separator: ", "))
                        }
                        
                        detailRow(label: "Type", value: movie.type.capitalized)
                        detailRow(label: "Adult", value: movie.isAdult == true ? "Yes": "No")
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $showingPlaylistSelector) {
            PlaylistSelectorView(
                playlists: viewModel.userPlaylists,
                selectedPlaylists: $viewModel.selectedPlaylists,
                isPresented: $showingPlaylistSelector,
                onDone: {
                    viewModel.togglePlaylistSelections()
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
