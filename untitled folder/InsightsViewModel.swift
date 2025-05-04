import Foundation
import CoreData

class InsightsViewModel: ObservableObject {
    @Published var userStats: UserStats?
    @Published var genreDistribution: [String: Int] = [:]
    
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
        loadUserStats()
    }
    
    func loadUserStats() {
        userStats = repository.fetchUserStats()
        calculateGenreDistribution()
    }
    
    private func calculateGenreDistribution() {
        guard let stats = userStats else { return }
        
        let fetchRequest: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND isDefault == true", "Completed")
        
        guard let completedList = try? CoreDataManager.shared.context.fetch(fetchRequest).first else { return }
        
        let movies = CoreDataManager.shared.fetchMovies(for: completedList)
        
        var distribution: [String: Int] = [:]
        
        for movie in movies {
            if let genres = movie.genres as? [String] {
                for genre in genres {
                    distribution[genre] = (distribution[genre] ?? 0) + 1
                }
            }
        }
        
        genreDistribution = distribution
    }
}
