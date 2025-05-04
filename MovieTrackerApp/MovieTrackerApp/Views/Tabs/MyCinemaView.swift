//
//  MyCinemaView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI
import Foundation

//struct MyCinemaView: View {
//    @ObservedObject var viewModel: MyCinemaViewModel
//    @State private var showingAddPlaylist = false
//    @State private var newPlaylistName = ""
//    @State private var showingSettings = false
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Playlists section
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(viewModel.playlists, id: \.id) { playlist in
//                            Button(action: {
//                                viewModel.selectPlaylist(playlist)
//                            }) {
//                                Text(playlist.name)
//                                    .fontWeight(viewModel.selectedPlaylist?.id == playlist.id ? .bold : .regular)
//                                    .padding(.vertical, 8)
//                                    .padding(.horizontal, 16)
//                                    .background(viewModel.selectedPlaylist?.id == playlist.id ? Color.accentColor : Color.gray.opacity(0.2))
//                                    .foregroundColor(viewModel.selectedPlaylist?.id == playlist.id ? .white : .primary)
//                                    .cornerRadius(20)
//                            }
//                        }
//                        
//                        // Add playlist button
//                        Button(action: {
//                            showingAddPlaylist = true
//                        }) {
//                            Image(systemName: "plus")
//                                .font(.body)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 12)
//                                .background(Color.gray.opacity(0.2))
//                                .foregroundColor(.primary)
//                                .cornerRadius(20)
//                        }
//                    }
//                    .padding()
//                }
//                
//                // Movies in selected playlist
//                VStack(alignment: .leading, spacing: 16) {
//                    if let selectedPlaylist = viewModel.selectedPlaylist {
//                        Text(selectedPlaylist.name)
//                            .font(.headline)
//                            .padding(.horizontal)
//                        
//                        if viewModel.moviesInSelectedPlaylist.isEmpty {
//                            EmptyStateView(
//                                title: "No movies yet",
//                                message: "Movies you add to this playlist will appear here",
//                                systemImage: "film"
//                            )
//                        } else {
//                            ScrollView {
//                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
//                                    ForEach(viewModel.moviesInSelectedPlaylist) { movie in
//                                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
//                                            MovieTile(movie: movie)
//                                        }
//                                    }
//                                }
//                                .padding(.horizontal)
//                            }
//                        }
//                    }
//                    
//                    Divider()
//                        .padding(.vertical)
//                    
//                    // Recommendations section
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Recommendations")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        
//                        if viewModel.isLoading {
//                            LoadingView(message: "Loading recommendations...")
//                                .frame(height: 200)
//                        } else if let error = viewModel.errorMessage {
//                            ErrorView(message: error) {
//                                viewModel.loadRecommendedMovies()
//                            }
//                            .frame(height: 200)
//                        } else if viewModel.recommendedMovies.isEmpty {
//                            EmptyStateView(
//                                title: "No recommendations yet",
//                                message: "Mark some movies as completed to get personalized recommendations",
//                                systemImage: "sparkles"
//                            )
//                            .frame(height: 200)
//                        } else {
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: 16) {
//                                    ForEach(viewModel.recommendedMovies) { movie in
//                                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
//                                            MovieTile(movie: movie)
//                                                .frame(width: 150)
//                                        }
//                                    }
//                                }
//                                .padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("My Cinema")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        showingSettings = true
//                    }) {
//                        Image(systemName: "gearshape")
//                    }
//                }
//            }
//            .sheet(isPresented: $showingAddPlaylist) {
//                AddPlaylistView(isPresented: $showingAddPlaylist) { name in
//                    viewModel.createPlaylist(name: name)
//                }
//            }
//            .sheet(isPresented: $showingSettings) {
//                SettingsView(isPresented: $showingSettings)
//            }
//        }
//    }
//}

struct MyCinemaView: View {
    @ObservedObject var viewModel: MyCinemaViewModel
    @State private var showingAddPlaylist = false
    @State private var newPlaylistName = ""
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // My Movie Lists section
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Movie Lists")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Horizontal grid of playlist tiles
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.playlists, id: \.id) { playlist in
                                NavigationLink(destination: MovieListView(viewModel: viewModel, playlist: playlist)) {
                                    PlaylistTile(name: playlist.name, isDefault: playlist.isDefault)
                                }
                            }
                            
                            // Add playlist button
                            Button(action: {
                                showingAddPlaylist = true
                            }) {
                                AddPlaylistTile()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 100)
                }
                
                // Recommended For You section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recommended For You")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if viewModel.isLoading {
                        LoadingView(message: "Loading recommendations...")
                            .frame(height: 200)
                    } else if let error = viewModel.errorMessage {
                        ErrorView(message: error) {
                            viewModel.loadRecommendedMovies()
                        }
                        .frame(height: 200)
                    } else if viewModel.recommendedMovies.isEmpty {
                        EmptyStateView(
                            title: "No recommendations yet",
                            message: "Mark some movies as completed to get personalized recommendations",
                            systemImage: "sparkles"
                        )
                        .frame(height: 200)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 12) { // Reduced spacing
                                ForEach(viewModel.recommendedMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                        MovieTile(movie: movie)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }                    }
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("My Cinema")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingAddPlaylist) {
                AddPlaylistView(isPresented: $showingAddPlaylist) { name in
                    viewModel.createPlaylist(name: name)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(isPresented: $showingSettings)
            }
            .onAppear {
                // This will reload playlists each time the view appears
                viewModel.refresh()
            }
            
        }
    }
}
