//
//  MovieListView.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

import SwiftUI
import CoreData

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    let playlist: PlayList
    
    init(playlist: PlayList) {
        self.playlist = playlist
        self.viewModel = MovieListViewModel(playlist: playlist)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.movies, id: \.self) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRow(movie: movie)
                }
                .swipeActions(edge: .trailing) {
                    if playlist.name == "Watchlist" {
                        Button(action: {
                            viewModel.markAsCompleted(movie)
                        }) {
                            Label("Complete", systemImage: "checkmark")
                        }
                        .tint(.green)
                    }
                    
                    Button(role: .destructive) {
                        viewModel.removeMovie(movie)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(playlist.name ?? "Movies")
        .onAppear {
            viewModel.loadMovies(for: playlist)
        }
    }
}

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            if let imageUrl = movie.primaryImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 75)
                .cornerRadius(4)
            } else {
                Image(systemName: "film")
                    .frame(width: 50, height: 75)
                    .background(Color.gray)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading) {
                Text(movie.primaryTitle ?? "Unknown Title")
                    .font(.headline)
                
                if let genres = movie.genres as? [String] {
                    Text(genres.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.averageRating))
                }
                .font(.caption)
            }
        }
    }
}
