//
//  MyCinemaView.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

import SwiftUI
import CoreData

struct MyCinemaView: View {
    @StateObject private var viewModel = MyCinemaViewModel()
    @EnvironmentObject private var settings: Settings
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Playlists Section
                    Text("My Movie Lists")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.playlists, id: \.self) { playlist in
                                NavigationLink(destination: MovieListView(playlist: playlist)) {
                                    PlaylistCard(playlist: playlist)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recommendations Section
                    Text("Recommended For You")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.recommendedMovies, id: \.id) { movie in
                                NavigationLink(destination: MovieDetailView(movieData: movie)) {
                                    MoviePoster(movie: movie)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("My Cinema")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { settings.isDarkMode.toggle() }) {
                        Image(systemName: settings.isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                }
            }
        }
    }
}

struct PlaylistCard: View {
    let playlist: PlayList
    
    var body: some View {
        VStack {
            Image(systemName: playlist.name == "Watchlist" ? "list.bullet" : "checkmark.seal.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(playlist.name == "Watchlist" ? Color.blue : Color.green)
                .cornerRadius(10)
            
            Text(playlist.name ?? "")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}
