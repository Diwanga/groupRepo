//
//  MovieListView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-04.
//
import SwiftUI

// Movie List View (shown when a playlist is selected)
struct MovieListView: View {
    @ObservedObject var viewModel: MyCinemaViewModel
    let playlist: Playlist
    
    var body: some View {
        List {
            ForEach(viewModel.moviesInSelectedPlaylist) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                    HStack {
                        // Movie poster
                        if let imageURL = movie.imageURL {
                            AsyncImage(url: imageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(6)
                                } else if phase.error != nil {
                                    Image(systemName: "film")
                                        .frame(width: 50, height: 75)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(6)
                                } else {
                                    ProgressView()
                                        .frame(width: 50, height: 75)
                                }
                            }
                        } else {
                            Image(systemName: "film")
                                .frame(width: 50, height: 75)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(6)
                        }
                        
                        // Movie info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                            
                            Text(movie.genres.prefix(3).joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                
                                Text(String(format: "%.1f", movie.rating))
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(playlist.name)
        .onAppear {
            viewModel.selectPlaylist(playlist)
        }
    }
}
