////
////  MovieDetailView.swift
////  MovieTracker
////
////  Created by Diwanga Amasith on 2025-05-02.
////
//
//import SwiftUI
//import CoreData
//
//struct MovieDetailView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @EnvironmentObject private var repository: MovieRepository
//    @State private var isInWatchlist = false
//    @State private var isCompleted = false
//    
//    var movieData: MovieData?
//    var movie: Movie?
//    
//    init(movieData: MovieData) {
//        self.movieData = movieData
//    }
//    
//    init(movie: Movie) {
//        self.movie = movie
//    }
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                // Banner Image
//                if let bannerUrl = currentMovie.primaryImage, let url = URL(string: bannerUrl) {
//                    AsyncImage(url: url) { image in
//                        image.resizable()
//                            .scaledToFit()
//                    } placeholder: {
//                        Color.gray
//                    }
//                    .frame(height: 250)
//                    .cornerRadius(10)
//                }
//                
//                // Title and Rating
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(currentMovie.primaryTitle)
//                        .font(.title)
//                        .fontWeight(.bold)
//                    
//                    HStack {
//                        Image(systemName: "star.fill")
//                            .foregroundColor(.yellow)
//                        Text(String(format: "%.1f", currentMovie.averageRating ?? 0.0))
////                        Text("(\(currentMovie.numVotes) votes)")
////                            .foregroundColor(.secondary)
//                    }
//                    
//                    if let genres = currentMovie.genres as? [String] {
//                        Text(genres.joined(separator: ", "))
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                
//                // Action Buttons
//                HStack(spacing: 20) {
//                    if !isCompleted {
//                        Button(action: markAsCompleted) {
//                            VStack {
//                                Image(systemName: "checkmark")
//                                    .font(.title)
//                                Text("Complete")
//                                    .font(.caption)
//                            }
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.green)
//                    }
//                    
//                    Button(action: toggleWatchlist) {
//                        VStack {
//                            Image(systemName: isInWatchlist ? "bookmark.fill" : "bookmark")
//                                .font(.title)
//                            Text(isInWatchlist ? "In Watchlist" : "Add to Watchlist")
//                                .font(.caption)
//                        }
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.blue)
//                }
//                .frame(maxWidth: .infinity)
//                
//                // Details
//                VStack(alignment: .leading, spacing: 10) {
////                    if let description = currentMovie.movieDescription {
////                        Text(description)
////                            .font(.body)
////                    }
////                    
//                    Divider()
//                    
//  //                  DetailRow(icon: "calendar", text: currentMovie.releaseDate?.formatted(date: .long, time: .omitted) ?? "Unknown")
//                    
////                    if let runtime = currentMovie.runtimeMinutes {
////                        DetailRow(icon: "clock", text: "\(runtime) minutes")
////                    }
//                    
//                    if let contentRating = currentMovie.contentRating {
//                        DetailRow(icon: "person.crop.circle.badge.exclamationmark", text: contentRating)
//                    }
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(currentMovie.primaryTitle)
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            checkMovieStatus()
//        }
//    }
//    
//    private var currentMovie: MovieData {
//        if let movie = movie {
//            return MovieData(
//                id: movie.id ?? "",
//                url: nil,
//                primaryTitle: movie.primaryTitle ?? "Unknown",
//                originalTitle: movie.originalTitle,
//                type: movie.type ?? "movie",
////                movieDescription: movie.movieDescription,
//                primaryImage: movie.primaryImage,
//                trailer: movie.trailer,
//                contentRating: movie.contentRating,
//                isAdult: movie.isAdult,
//                releaseDate: nil,
//                startYear: nil,
//                endYear: nil,
////                runtimeMinutes: Int(movie.runtimeMinutes),
//                genres: movie.genres as? [String],
//                averageRating: movie.averageRating
////                numVotes: Int(movie.numVotes
//            )
//        } else if let movieData = movieData {
//            return movieData
//        } else {
//            return MovieData(
//                id: "",
//                url: nil,
//                primaryTitle: "Unknown",
//                originalTitle: nil,
//                type: "movie",
////                movieDescription: nil,
//                primaryImage: nil,
//                trailer: nil,
//                contentRating: nil,
//                isAdult: false,
//                releaseDate: nil,
//                startYear: nil,
//                endYear: nil,
////                runtimeMinutes: nil,
//                genres: nil,
//                averageRating: nil
////                numVotes: nil
//            )
//        }
//    }
//    
//    private func checkMovieStatus() {
//        guard let movieId = movie?.id ?? movieData?.id else { return }
//        
//        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Watchlist")
//        
//        if let watchlist = try? viewContext.fetch(fetchRequest).first {
//            let movies = repository.fetchMovies(for: watchlist)
//            isInWatchlist = movies.contains { $0.id == movieId }
//        }
//        
//        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
//        
//        if let completedList = try? viewContext.fetch(fetchRequest).first {
//            let movies = repository.fetchMovies(for: completedList)
//            isCompleted = movies.contains { $0.id == movieId }
//        }
//    }
//    
//    private func toggleWatchlist() {
//        guard let movieId = movie?.id ?? movieData?.id else { return }
//        
//        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Watchlist")
//        
//        if let watchlist = try? viewContext.fetch(fetchRequest).first {
//            if isInWatchlist {
//                // Remove from watchlist
//                if let existingMovie = movie {
//                    repository.removeMovieFromWatchlist(existingMovie, playlist: watchlist)
//                }
//            } else {
//                // Add to watchlist
//                if let movieData = movieData {
//                    _ = repository.saveMovie(movieData, to: watchlist)
//                } else if let movie = movie {
//                    repository.saveMovie(currentMovie, to: watchlist)
//                }
//            }
//            isInWatchlist.toggle()
//        }
//    }
//    
//    private func markAsCompleted() {
//        if let movie = movie {
//            repository.markMovieAsCompleted(movie)
//            isCompleted = true
//        } else if let movieData = movieData {
//            let movie = repository.saveMovie(movieData, to: nil)
//            repository.markMovieAsCompleted(movie)
//            isCompleted = true
//        }
//    }
//}
//
//struct DetailRow: View {
//    let icon: String
//    let text: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .frame(width: 30)
//            Text(text)
//            Spacer()
//        }
//    }
//}
//
//
//
//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = CoreDataManager.shared.context
//        let repository = MovieRepository()
//        
//        return NavigationView {
//            MovieDetailView(movieData: MovieData(
//                id: "tt1234567",
//                url: "https://www.imdb.com/title/tt1234567/",
//                primaryTitle: "Sample Movie",
//                originalTitle: "Sample Movie Original",
//                type: "movie",
//                // description: "This is a sample movie description", // Commented to match your struct
//                primaryImage: nil,
//                trailer: nil,
//                contentRating: "PG-13",
//                isAdult: false,
//                releaseDate: "2023-01-15",
//                startYear: 2023,
//                endYear: nil,
//                // runtimeMinutes: 120, // Commented to match your struct
//                genres: ["Action", "Adventure"],
//                averageRating: 7.5
//                // numVotes: 1000 // Commented to match your struct
//            ))
//            .environment(\.managedObjectContext, context)
//            .environmentObject(repository)
//        }
//    }
//}


//
//  MovieDetailView.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import SwiftUI
import CoreData

struct MovieDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var repository: MovieRepository
    @State private var isInWatchlist = false
    @State private var isCompleted = false
    
    var movieData: MovieData?
    var movie: Movie?
    
    init(movieData: MovieData) {
        self.movieData = movieData
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Banner Image
                if let bannerUrl = currentMovie.primaryImage, let url = URL(string: bannerUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 250)
                    .cornerRadius(10)
                } else {
                    // Fallback image if no URL is available
                    Image(systemName: "film")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                // Title and Rating
                VStack(alignment: .leading, spacing: 8) {
                    Text(currentMovie.primaryTitle)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", currentMovie.averageRating ?? 0.0))
                    }
                    
                    if let genres = currentMovie.genres, !genres.isEmpty {
                        Text(genres.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Action Buttons
                HStack(spacing: 20) {
                    if !isCompleted {
                        Button(action: markAsCompleted) {
                            VStack {
                                Image(systemName: "checkmark")
                                    .font(.title)
                                Text("Complete")
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    
                    Button(action: toggleWatchlist) {
                        VStack {
                            Image(systemName: isInWatchlist ? "bookmark.fill" : "bookmark")
                                .font(.title)
                            Text(isInWatchlist ? "In Watchlist" : "Add to Watchlist")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity)
                
                // Details
                VStack(alignment: .leading, spacing: 10) {
                    Divider()
                    
                    if let releaseDate = currentMovie.releaseDate {
                        DetailRow(icon: "calendar", text: releaseDate)
                    }
                    
                    if let contentRating = currentMovie.contentRating {
                        DetailRow(icon: "person.crop.circle.badge.exclamationmark", text: contentRating)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(currentMovie.primaryTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkMovieStatus()
        }
    }
    
    private var currentMovie: MovieData {
        if let movie = movie {
            return MovieData(
                id: movie.id ?? "",
                url: nil,
                primaryTitle: movie.primaryTitle ?? "Unknown",
                originalTitle: movie.originalTitle,
                type: movie.type ?? "movie",
                primaryImage: movie.primaryImage,
                trailer: movie.trailer,
                contentRating: movie.contentRating,
                isAdult: movie.isAdult,
                releaseDate: nil,
                startYear: nil,
                endYear: nil,
                genres: movie.genres as? [String],
                averageRating: movie.averageRating
            )
        } else if let movieData = movieData {
            return movieData
        } else {
            return MovieData(
                id: "",
                url: nil,
                primaryTitle: "Unknown",
                originalTitle: nil,
                type: "movie",
                primaryImage: nil,
                trailer: nil,
                contentRating: nil,
                isAdult: false,
                releaseDate: nil,
                startYear: nil,
                endYear: nil,
                genres: nil,
                averageRating: nil
            )
        }
    }
    
    private func checkMovieStatus() {
        guard let movieId = movie?.id ?? movieData?.id else { return }
        
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Watchlist")
        
        if let watchlist = try? viewContext.fetch(fetchRequest).first {
            let movies = repository.fetchMovies(for: watchlist)
            isInWatchlist = movies.contains { $0.id == movieId }
        }
        
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
        
        if let completedList = try? viewContext.fetch(fetchRequest).first {
            let movies = repository.fetchMovies(for: completedList)
            isCompleted = movies.contains { $0.id == movieId }
        }
    }
    
    private func toggleWatchlist() {
        guard let movieId = movie?.id ?? movieData?.id else { return }
        
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Watchlist")
        
        guard let watchlist = try? viewContext.fetch(fetchRequest).first else { return }
        
        if isInWatchlist {
            // Remove from watchlist
            if let existingMovie = movie {
                repository.removeMovieFromWatchlist(existingMovie, playlist: watchlist)
            }
        } else {
            // Add to watchlist
            if let movieData = movieData {
                _ = repository.saveMovie(movieData, to: watchlist)
            } else if let movie = movie {
                let movieData = currentMovie
                _ = repository.saveMovie(movieData, to: watchlist)
            }
        }
        isInWatchlist.toggle()
    }
    
    private func markAsCompleted() {
        if let movie = movie {
            repository.markMovieAsCompleted(movie)
            isCompleted = true
        } else if let movieData = movieData {
            let movie = repository.saveMovie(movieData, to: nil)
            repository.markMovieAsCompleted(movie)
            isCompleted = true
        }
    }
}

struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            Text(text)
            Spacer()
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.context
        let repository = MovieRepository()
        
        return NavigationView {
            MovieDetailView(movieData: MovieData(
                id: "tt1234567",
                url: "https://www.imdb.com/title/tt1234567/",
                primaryTitle: "Sample Movie",
                originalTitle: "Sample Movie Original",
                type: "movie",
                primaryImage: nil,
                trailer: nil,
                contentRating: "PG-13",
                isAdult: false,
                releaseDate: "2023-01-15",
                startYear: 2023,
                endYear: nil,
                genres: ["Action", "Adventure"],
                averageRating: 7.5
            ))
            .environment(\.managedObjectContext, context)
            .environmentObject(repository)
        }
    }
}
