

import Foundation

class DiscoverViewModel: ObservableObject {
    @Published var movies: [MovieData] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchQuery = ""
    @Published var selectedGenre = ""
    @Published var minRating: Double?
    
    private let repository: MovieRepositoryProtocol
    
    let genres = ["Action", "Adventure", "Animation", "Comedy", "Crime",
                 "Documentary", "Drama", "Family", "Fantasy", "History",
                 "Horror", "Music", "Mystery", "Romance", "Science Fiction",
                 "Thriller", "War", "Western"]
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
        fetchPopularMovies()
    }
    
    func fetchPopularMovies() {
        isLoading = true
        repository.fetchMovies(searchQuery: nil, genre: nil, minRating: 7.0) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func searchMovies() {
        isLoading = true
        repository.fetchMovies(searchQuery: searchQuery.isEmpty ? nil : searchQuery,
                              genre: selectedGenre.isEmpty ? nil : selectedGenre,
                              minRating: minRating) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
