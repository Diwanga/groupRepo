
import Foundation
import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var showSearchFilters = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                    } else {
                        MovieGrid(movies: viewModel.movies)
                    }
                }
                .padding()
            }
            .navigationTitle("Discover")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSearchFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showSearchFilters) {
                SearchFiltersView(viewModel: viewModel)
            }
        }
    }
}

struct MovieGrid: View {
    let movies: [MovieData]
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 150), spacing: 20),
                GridItem(.adaptive(minimum: 150), spacing: 20)
            ],
            spacing: 20
        ) {
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetailView(movieData: movie)) {
                    MoviePoster(movie: movie)
                }
            }
        }
    }
}

struct MoviePoster: View {
    let movie: MovieData
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = movie.primaryImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(2/3, contentMode: .fit)
                .cornerRadius(8)
            } else {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(movie.primaryTitle)
                .font(.subheadline)
                .lineLimit(1)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                
                Text(String(format: "%.1f", movie.averageRating ?? 0))
                    .font(.caption)
            }
        }
    }
}
