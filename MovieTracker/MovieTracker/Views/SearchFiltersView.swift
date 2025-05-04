//
//  SearchFiltersView.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

import SwiftUI

struct SearchFiltersView: View {
    @ObservedObject var viewModel: DiscoverViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search Filters")) {
                    TextField("Search by title", text: $viewModel.searchQuery)
                    
                    Picker("Genre", selection: $viewModel.selectedGenre) {
                        Text("All Genres").tag("")
                        ForEach(viewModel.genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    
                    HStack {
                        Text("Minimum Rating: \(String(format: "%.1f", viewModel.minRating ?? 0))")
                        Slider(value: Binding(
                            get: { viewModel.minRating ?? 0 },
                            set: { viewModel.minRating = $0 }
                        ), in: 0...10, step: 0.5)
                    }
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.searchMovies()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
