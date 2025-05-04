import XCTest
import Foundation
import Combine
import CoreData
@testable import MovieTrackerApp

// MARK: - Repository Tests
class MovieRepositoryTests: XCTestCase {
    var sut: MovieRepository!
    var mockPersistenceController: MockPersistenceController!
    var mockAPIService: MockMovieAPIService!

    // Fix for the persistence controller error
    override func setUp() {
        super.setUp()
        mockPersistenceController = MockPersistenceController(inMemory: true) // Remove the optional
        mockAPIService = MockMovieAPIService()
        sut = MovieRepository(persistenceController: mockPersistenceController, apiService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockPersistenceController = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testGetPlaylistsReturnsCorrectPlaylists() {
        // Given
        let playlist1 = createTestPlaylist(name: "Test Playlist 1", isDefault: true)
        let playlist2 = createTestPlaylist(name: "Test Playlist 2", isDefault: false)
        
        // When
        let playlists = sut.getPlaylists()
        
        // Then
        XCTAssertEqual(playlists.count, 2)
        XCTAssertTrue(playlists.contains { $0.name == "Test Playlist 1" && $0.isDefault })
        XCTAssertTrue(playlists.contains { $0.name == "Test Playlist 2" && !$0.isDefault })
    }
    
    func testCreatePlaylistCreatesNewPlaylist() {
        // Given
        let playlistName = "New Playlist"
        
        // When
        let playlist = sut.createPlaylist(name: playlistName)
        
        // Then
        XCTAssertEqual(playlist.name, playlistName)
        XCTAssertFalse(playlist.isDefault)
        
        // And the playlist should now be retrievable
        let playlists = sut.getPlaylists()
        XCTAssertTrue(playlists.contains { $0.name == playlistName })
    }
    
    func testGetPlaylistByNameReturnsCorrectPlaylist() {
        // Given
        let playlist = createTestPlaylist(name: "Test Playlist", isDefault: false)
        
        // When
        let retrievedPlaylist = sut.getPlaylist(withName: "Test Playlist")
        
        // Then
        XCTAssertNotNil(retrievedPlaylist)
        XCTAssertEqual(retrievedPlaylist?.name, playlist.name)
    }
    
    func testDeletePlaylistRemovesPlaylist() {
        // Given
        let playlist = createTestPlaylist(name: "Test Playlist", isDefault: false)
        
        // When
        sut.deletePlaylist(playlist)
        
        // Then
        let retrievedPlaylist = sut.getPlaylist(withName: "Test Playlist")
        XCTAssertNil(retrievedPlaylist)
    }
    
    func testDeleteDefaultPlaylistDoesNotDelete() {
        // Given
        let playlist = createTestPlaylist(name: "Default Playlist", isDefault: true)
        
        // When
        sut.deletePlaylist(playlist)
        
        // Then
        let retrievedPlaylist = sut.getPlaylist(withName: "Default Playlist")
        XCTAssertNotNil(retrievedPlaylist)
    }
    
    func testAddMovieToPlaylist() {
        // Given
        let playlist = createTestPlaylist(name: "Test Playlist", isDefault: false)
        let movieData = createTestMovieResponse(id: "tt1234567")
        
        // When
        let movie = sut.addMovie(movieData, toPlaylist: playlist)
        
        // Then
        XCTAssertEqual(movie.id, "tt1234567")
        XCTAssertEqual(movie.primaryTitle, "Test Movie")
        
        // And the movie should be in the playlist
        let movies = sut.getMovies(inPlaylist: playlist)
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.id, "tt1234567")
    }
    
    func testRemoveMovieFromPlaylist() {
        // Given
        let playlist = createTestPlaylist(name: "Test Playlist", isDefault: false)
        let movieData = createTestMovieResponse(id: "tt1234567")
        let movie = sut.addMovie(movieData, toPlaylist: playlist)
        
        // When
        sut.removeMovie(movie, fromPlaylist: playlist)
        
        // Then
        let movies = sut.getMovies(inPlaylist: playlist)
        XCTAssertEqual(movies.count, 0)
    }
    
    func testMarkMovieAsCompletedAddsToCompletedPlaylist() {
        // Given
        let completedPlaylist = createTestPlaylist(name: "Completed", isDefault: true)
        let movie = createTestMovie(id: "tt1234567", title: "Test Movie")
        
        // When
        sut.markMovieAsCompleted(movie, isCompleted: true)
        
        // Then
        XCTAssertTrue(movie.isCompleted)
        XCTAssertTrue(sut.isMovieInPlaylist(movie.id, playlist: completedPlaylist))
    }
    
    func testGetUserStatsCreatesDefaultStatsWhenNoneExist() {
        // When
        let stats = sut.getUserStats()
        
        // Then
        XCTAssertEqual(stats.totalWatchedMovieCount, 0)
        XCTAssertEqual(stats.totalWatchHours, 0)
        XCTAssertEqual(stats.averageRating, 0)
    }
    
    func testUpdateUserStatsUpdatesCorrectly() {
        // Given
        let movie = createTestMovie(id: "tt1234567", title: "Test Movie", runtime: 120, rating: 8.5)
        
        // When
        sut.updateUserStats(movie: movie)
        
        // Then
        let stats = sut.getUserStats()
        XCTAssertEqual(stats.totalWatchedMovieCount, 1)
        XCTAssertEqual(stats.totalWatchHours, 2.0) // 120 minutes = 2 hours
        XCTAssertEqual(stats.averageRating, 8.5)
    }
    
    func testGetUserFavoriteGenreAndRating() {
        // Given
        let movie1 = createTestMovie(id: "tt1234567", title: "Movie 1", genres: ["Action", "Thriller"])
        let movie2 = createTestMovie(id: "tt2345678", title: "Movie 2", genres: ["Action", "Drama"])
        
        // When
        sut.updateUserStats(movie: movie1)
        sut.updateUserStats(movie: movie2)
        
        // Then
        let result = sut.getUserFavoriteGenreAndRating()
        XCTAssertEqual(result.genre, "Action") // Action appears twice
        XCTAssertEqual(result.rating, 7.0) // Default rating for test movies
    }
    
    func testGetMovieFromCoreDataWhenAvailable() {
        // Given
        let movie = createTestMovie(id: "tt1234567", title: "Test Movie")
        
        // When
        let expectation = XCTestExpectation(description: "Get movie from Core Data")
        var receivedMovie: MovieResponse?
        
        sut.getMovie(id: "tt1234567")
            .sink(receiveCompletion: { _ in }, receiveValue: { movieResponse in
                receivedMovie = movieResponse
                expectation.fulfill()
            })
            .store(in: &mockAPIService.cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedMovie)
        XCTAssertEqual(receivedMovie?.id, "tt1234567")
        XCTAssertEqual(receivedMovie?.primaryTitle, "Test Movie")
    }
    
    func testGetMovieFromAPIWhenNotInCoreData() {
        // Given
        let mockMovie = createTestMovieResponse(id: "tt9876543")
        mockAPIService.mockMovie = mockMovie
        
        // When
        let expectation = XCTestExpectation(description: "Get movie from API")
        var receivedMovie: MovieResponse?
        
        sut.getMovie(id: "tt9876543")
            .sink(receiveCompletion: { _ in }, receiveValue: { movieResponse in
                receivedMovie = movieResponse
                expectation.fulfill()
            })
            .store(in: &mockAPIService.cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedMovie)
        XCTAssertEqual(receivedMovie?.id, "tt9876543")
        XCTAssertEqual(receivedMovie?.primaryTitle, "Test Movie")
    }
    
    // Helper methods
    private func createTestPlaylist(name: String, isDefault: Bool) -> Playlist {
        let context = mockPersistenceController.container.viewContext
        let playlist = Playlist(context: context)
        playlist.id = UUID()
        playlist.name = name
        playlist.isDefault = isDefault
        try? context.save()
        return playlist
    }
    
    private func createTestMovie(id: String = UUID().uuidString, title: String = "Test Movie", runtime: Int32 = 90, rating: Double = 7.0, genres: [String] = ["Action", "Drama"]) -> Movie {
        let context = mockPersistenceController.container.viewContext
        let movie = Movie(context: context)
        movie.id = id
        movie.primaryTitle = title
        movie.type = "movie"
        movie.runtimeMinutes = runtime
        movie.averageRating = rating
        movie.genres = genres
        try? context.save()
        return movie
    }
    
    private func createTestMovieResponse(id: String = "tt1234567") -> MovieResponse {
        return MovieResponse(
            id: id,
            url: "https://www.imdb.com/title/\(id)/",
            primaryTitle: "Test Movie",
            originalTitle: "Test Movie",
            type: "movie",
            description: "Test movie description",
            primaryImage: "https://example.com/image.jpg",
            trailer: nil,
            contentRating: "PG-13",
            isAdult: false,
            releaseDate: "2023-01-01",
            startYear: 2023,
            endYear: nil,
            runtimeMinutes: 120,
            genres: ["Action", "Drama"],
            interests: nil,
            countriesOfOrigin: ["US"],
            spokenLanguages: ["en"],
            averageRating: 7.5,
            numVotes: 1000
        )
    }
}

// MARK: - ViewModel Tests
class MyCinemaViewModelTests: XCTestCase {
    var sut: MyCinemaViewModel!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = MyCinemaViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadPlaylistsLoadsCorrectPlaylists() {
        // Given
        let playlist1 = MockPlaylist(id: UUID(), name: "Test 1", isDefault: true)
        let playlist2 = MockPlaylist(id: UUID(), name: "Test 2", isDefault: false)
        mockRepository.mockPlaylists = [playlist1, playlist2]
        
        // When
        sut.loadPlaylists()
        
        // Then
        XCTAssertEqual(sut.playlists.count, 2)
        XCTAssertEqual(sut.playlists[0].name, "Test 1")
        XCTAssertEqual(sut.playlists[1].name, "Test 2")
    }
    
    func testSelectPlaylistUpdatesSelectedPlaylist() {
        // Given
        let playlist1 = MockPlaylist(id: UUID(), name: "Test 1", isDefault: true)
        let playlist2 = MockPlaylist(id: UUID(), name: "Test 2", isDefault: false)
        mockRepository.mockPlaylists = [playlist1, playlist2]
        sut.loadPlaylists()
        
        // When
        sut.selectPlaylist(sut.playlists[1])
        
        // Then
        XCTAssertEqual(sut.selectedPlaylist?.name, "Test 2")
    }
    
    func testLoadMoviesInSelectedPlaylistLoadsCorrectMovies() {
        // Given
        let playlist = MockPlaylist(id: UUID(), name: "Test Playlist", isDefault: false)
        let movie1 = MockMovie(id: "tt1", title: "Movie 1", isCompleted: false)
        let movie2 = MockMovie(id: "tt2", title: "Movie 2", isCompleted: true)
        mockRepository.mockPlaylists = [playlist]
        mockRepository.mockMovies = [movie1, movie2]
        
        // When
        sut.loadPlaylists()
        sut.selectPlaylist(sut.playlists[0])
        
        // Then
        XCTAssertEqual(sut.moviesInSelectedPlaylist.count, 2)
        XCTAssertEqual(sut.moviesInSelectedPlaylist[0].title, "Movie 1")
        XCTAssertEqual(sut.moviesInSelectedPlaylist[1].title, "Movie 2")
    }
    
    func testCreatePlaylistAddsNewPlaylist() {
        // Given
        let initialCount = sut.playlists.count
        
        // When
        sut.createPlaylist(name: "New Playlist")
        
        // Then
        XCTAssertEqual(sut.playlists.count, initialCount + 1)
        XCTAssertTrue(sut.playlists.contains { $0.name == "New Playlist" })
    }
    
    func testLoadRecommendedMoviesUsesUserFavoriteGenreAndRating() {
        // Given
        mockRepository.favoriteGenreAndRating = ("Action", 8.0)
        mockRepository.recommendedMoviesResult = [
            createTestMovieResponse(id: "tt1", title: "Action Movie 1"),
            createTestMovieResponse(id: "tt2", title: "Action Movie 2")
        ]
        
        // When
        sut.loadRecommendedMovies()
        
        // Then
        XCTAssertEqual(mockRepository.lastGenreRequested, "Action")
        XCTAssertEqual(mockRepository.lastRatingRequested, 8.0)
        XCTAssertEqual(sut.recommendedMovies.count, 2)
        XCTAssertEqual(sut.recommendedMovies[0].title, "Action Movie 1")
        XCTAssertEqual(sut.recommendedMovies[1].title, "Action Movie 2")
    }
    
    func testRefreshReloadsPlaylists() {
        // Given
        let playlist1 = MockPlaylist(id: UUID(), name: "Test 1", isDefault: true)
        mockRepository.mockPlaylists = [playlist1]
        sut.loadPlaylists()
        XCTAssertEqual(sut.playlists.count, 1)
        
        // Add another playlist
        let playlist2 = MockPlaylist(id: UUID(), name: "Test 2", isDefault: false)
        mockRepository.mockPlaylists = [playlist1, playlist2]
        
        // When
        sut.refresh()
        
        // Then
        XCTAssertEqual(sut.playlists.count, 2)
    }
    
    // Helper method
    private func createTestMovieResponse(id: String, title: String) -> MovieResponse {
        return MovieResponse(
            id: id,
            url: "https://www.imdb.com/title/\(id)/",
            primaryTitle: title,
            originalTitle: title,
            type: "movie",
            description: "Description for \(title)",
            primaryImage: "https://example.com/\(id).jpg",
            trailer: nil,
            contentRating: "PG-13",
            isAdult: false,
            releaseDate: "2023-01-01",
            startYear: 2023,
            endYear: nil,
            runtimeMinutes: 120,
            genres: ["Action", "Drama"],
            interests: nil,
            countriesOfOrigin: ["US"],
            spokenLanguages: ["en"],
            averageRating: 7.5,
            numVotes: 1000
        )
    }
}

// MARK: - Discover View Model Tests
class DiscoverViewModelTests: XCTestCase {
    var sut: DiscoverViewModel!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = DiscoverViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadPopularMovies() {
        // Given
        mockRepository.popularMoviesResult = [
            createTestMovieResponse(id: "tt1", title: "Popular Movie 1"),
            createTestMovieResponse(id: "tt2", title: "Popular Movie 2")
        ]
        
        // When
        sut.loadPopularMovies()
        
        // Then
        XCTAssertEqual(sut.movies.count, 2)
        XCTAssertEqual(sut.movies[0].title, "Popular Movie 1")
        XCTAssertEqual(sut.movies[1].title, "Popular Movie 2")
    }
    
    func testSearchMovies() {
        // Given
        mockRepository.searchMoviesResult = [
            createTestMovieResponse(id: "tt1", title: "Search Result 1"),
            createTestMovieResponse(id: "tt2", title: "Search Result 2")
        ]
        sut.searchText = "Test Query"
        sut.selectedGenre = "Action"
        sut.minRating = 7.5
        sut.yearFrom = 2020
        
        // When
        sut.searchMovies()
        
        // Then
        XCTAssertEqual(mockRepository.lastSearchQuery, "Test Query")
        XCTAssertEqual(mockRepository.lastSearchGenre, "Action")
        XCTAssertEqual(mockRepository.lastSearchRating, 7.5)
        XCTAssertEqual(mockRepository.lastSearchYear, 2020)
        XCTAssertEqual(sut.movies.count, 2)
        XCTAssertEqual(sut.movies[0].title, "Search Result 1")
        XCTAssertEqual(sut.movies[1].title, "Search Result 2")
    }
    
    func testClearSearch() {
        // Given
        sut.searchText = "Test Query"
        sut.selectedGenre = "Action"
        sut.minRating = 7.5
        sut.yearFrom = 2020
        
        // When
        sut.clearSearch()
        
        // Then
        XCTAssertEqual(sut.searchText, "")
        XCTAssertNil(sut.selectedGenre)
        XCTAssertEqual(sut.minRating, 0.0)
        XCTAssertNil(sut.yearFrom)
    }
    
    // Helper method
    private func createTestMovieResponse(id: String, title: String) -> MovieResponse {
        return MovieResponse(
            id: id,
            url: "https://www.imdb.com/title/\(id)/",
            primaryTitle: title,
            originalTitle: title,
            type: "movie",
            description: "Description for \(title)",
            primaryImage: "https://example.com/\(id).jpg",
            trailer: nil,
            contentRating: "PG-13",
            isAdult: false,
            releaseDate: "2023-01-01",
            startYear: 2023,
            endYear: nil,
            runtimeMinutes: 120,
            genres: ["Action", "Drama"],
            interests: nil,
            countriesOfOrigin: ["US"],
            spokenLanguages: ["en"],
            averageRating: 7.5,
            numVotes: 1000
        )
    }
}

// MARK: - Movie Detail View Model Tests
class MovieDetailViewModelTests: XCTestCase {
    var sut: MovieDetailViewModel!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = MovieDetailViewModel(movieId: "tt1234567", repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testToggleCompleted() {
        // Given
        let mockMovie = createTestMovieResponse()
        mockRepository.mockMovie = mockMovie
        sut.movie = mockMovie
        XCTAssertFalse(sut.isCompleted)
        
        // Create a completed playlist
        let completedPlaylist = MockPlaylist(id: UUID(), name: "Completed", isDefault: true)
        mockRepository.mockPlaylists = [completedPlaylist]
        
        // When
        sut.toggleCompleted()
        
        // Then
        XCTAssertTrue(sut.isCompleted)
        XCTAssertEqual(mockRepository.lastMarkedCompletedMovie?.id, "tt1234567")
    }
    
    func testToggleWatchlist() {
        // Given
        let mockMovie = createTestMovieResponse()
        mockRepository.mockMovie = mockMovie
        sut.movie = mockMovie
        XCTAssertFalse(sut.isInWatchlist)
        
        // Create a watchlist playlist
        let watchlistPlaylist = MockPlaylist(id: UUID(), name: "Watch List", isDefault: true)
        mockRepository.mockPlaylists = [watchlistPlaylist]
        
        // When
        sut.toggleWatchlist()
        
        // Then
        XCTAssertTrue(sut.isInWatchlist)
        XCTAssertEqual(mockRepository.lastAddedMovieToPlaylistId, "tt1234567")
        XCTAssertEqual(mockRepository.lastAddedMovieToPlaylistName, "Watch List")
    }
    
    func testUpdatePlaylistSelections() {
        // Given
        let mockMovie = createTestMovieResponse()
        mockRepository.mockMovie = mockMovie
        sut.movie = mockMovie
        
        // Create custom playlists
        let playlist1 = MockPlaylist(id: UUID(), name: "Custom 1", isDefault: false)
        let playlist2 = MockPlaylist(id: UUID(), name: "Custom 2", isDefault: false)
        mockRepository.mockPlaylists = [playlist1, playlist2]
        sut.userPlaylists = [playlist1, playlist2]
        
        // Select a playlist
        sut.selectedPlaylists.insert(playlist1.id)
        
        // When
        sut.togglePlaylistSelections()
        
        // Then
        XCTAssertEqual(mockRepository.lastAddedMovieToPlaylistId, "tt1234567")
        XCTAssertEqual(mockRepository.lastAddedMovieToPlaylistName, "Custom 1")
    }
    
    // Helper method
    private func createTestMovieResponse() -> MovieResponse {
        return MovieResponse(
            id: "tt1234567",
            url: "https://www.imdb.com/title/tt1234567/",
            primaryTitle: "Test Movie",
            originalTitle: "Test Movie",
            type: "movie",
            description: "Test movie description",
            primaryImage: "https://example.com/image.jpg",
            trailer: nil,
            contentRating: "PG-13",
            isAdult: false,
            releaseDate: "2023-01-01",
            startYear: 2023,
            endYear: nil,
            runtimeMinutes: 120,
            genres: ["Action", "Drama"],
            interests: nil,
            countriesOfOrigin: ["US"],
            spokenLanguages: ["en"],
            averageRating: 7.5,
            numVotes: 1000
        )
    }
}

// MARK: - Insights View Model Tests
class InsightsViewModelTests: XCTestCase {
    var sut: InsightsViewModel!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = InsightsViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadUserStats() {
        // Given
        let mockStats = MockUserStats()
        mockStats.mockTotalWatchedMovieCount = 10
        mockStats.mockTotalWatchHours = 20.5
        mockStats.mockAverageRating = 8.2
        mockStats.mockFavoriteGenre = "Action"
        mockStats.mockGenreDistribution = ["Action": 5, "Drama": 3, "Comedy": 2]
        mockRepository.mockUserStats = mockStats
        
        // When
        sut.loadUserStats()
        
        // Then
        XCTAssertEqual(sut.totalMoviesWatched, 10)
        XCTAssertEqual(sut.totalWatchHours, 20.5)
        XCTAssertEqual(sut.favoriteGenre, "Action")
        XCTAssertEqual(sut.averageRating, 8.2)
        XCTAssertEqual(sut.genreDistribution.count, 3)
        XCTAssertEqual(sut.genreDistribution["Action"], 5)
    }
}

// MARK: - Settings View Model Tests
class SettingsViewModelTests: XCTestCase {
    var sut: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = SettingsViewModel()
        // Ensure a known state
        UserDefaults.standard.set(false, forKey: "isDarkMode")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testToggleDarkMode() {
        // Given
        XCTAssertFalse(sut.isDarkMode)
        
        // When
        sut.toggleDarkMode()
        
        // Then
        XCTAssertTrue(sut.isDarkMode)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "isDarkMode"))
        
        // Toggle again
        sut.toggleDarkMode()
        XCTAssertFalse(sut.isDarkMode)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "isDarkMode"))
    }
}

// MARK: - Mock Classes
class MockPersistenceController: PersistenceController {
    override init(inMemory: Bool = true) {
        super.init(inMemory: true) // Always use in-memory store for tests
    }
}

class MockMovieAPIService: MovieAPIServiceProtocol {
    var mockSearchResults = IMDBSearchResponse(rows: 0, numFound: 0, results: [], nextCursorMark: nil)
    var mockMovie: MovieResponse?
    var cancellables = Set<AnyCancellable>()
    
    func searchMovies(query: String?, genre: String?, ratingFrom: Double?, rows: Int, year: Int?) -> AnyPublisher<IMDBSearchResponse, Error> {
        return Just(mockSearchResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getRecommendedMovies(genre: String, userRating: Double, count: Int) -> AnyPublisher<IMDBSearchResponse, Error> {
        return Just(mockSearchResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies(count: Int) -> AnyPublisher<IMDBSearchResponse, Error> {
        return Just(mockSearchResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMovie(id: String) -> AnyPublisher<MovieResponse, Error> {
        if let movie = mockMovie {
            return Just(movie)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "MockError", code: 404, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
}

class MockMovieRepository: MovieRepositoryProtocol {
    var mockPlaylists: [Playlist] = []
    var mockMovies: [Movie] = []
    var mockUserStats = MockUserStats()
    var favoriteGenreAndRating: (String, Double) = ("Sci-Fi", 7.0)
    
    // For testing API calls
    var recommendedMoviesResult: [MovieResponse] = []
    var popularMoviesResult: [MovieResponse] = []
    var searchMoviesResult: [MovieResponse] = []
    var mockMovie: MovieResponse? // Add this property
    
    // For tracking method calls
    var lastSearchQuery: String?
    var lastSearchGenre: String?
    var lastSearchRating: Double?
    var lastSearchYear: Int?
    var lastGenreRequested: String?
    var lastRatingRequested: Double?
    var lastAddedMovieToPlaylistId: String?
    var lastAddedMovieToPlaylistName: String?
    var lastMarkedCompletedMovie: Movie?
    
    func getPlaylists() -> [Playlist] {
        return mockPlaylists
    }
    
    func getPlaylist(withName name: String) -> Playlist? {
        return mockPlaylists.first { $0.name == name }
    }
    
    func createPlaylist(name: String, isDefault: Bool) -> Playlist {
        let playlist = MockPlaylist(id: UUID(), name: name, isDefault: isDefault)
        mockPlaylists.append(playlist)
        return playlist
    }
    
    func deletePlaylist(_ playlist: Playlist) {
        mockPlaylists.removeAll { $0.id == playlist.id }
    }
    
    func getMovies(inPlaylist playlist: Playlist) -> [Movie] {
        return mockMovies
    }
    
    func addMovie(_ movieData: MovieResponse, toPlaylist playlist: Playlist) -> Movie {
        lastAddedMovieToPlaylistId = movieData.id
        lastAddedMovieToPlaylistName = playlist.name
        let movie = MockMovie(id: movieData.id, title: movieData.primaryTitle, isCompleted: false)
        mockMovies.append(movie)
        return movie
    }
    
    func removeMovie(_ movie: Movie, fromPlaylist playlist: Playlist) {
        mockMovies.removeAll { $0.id == movie.id }
    }
    
    func markMovieAsCompleted(_ movie: Movie, isCompleted: Bool) {
        lastMarkedCompletedMovie = movie
        if let index = mockMovies.firstIndex(where: { $0.id == movie.id }) {
            (mockMovies[index] as! MockMovie).isCompleted = isCompleted
        }
    }
    
    func isMovieInPlaylist(_ movieId: String, playlist: Playlist) -> Bool {
        return mockMovies.contains { $0.id == movieId }
    }
    
    func searchMovies(query: String?, genre: String?, ratingFrom: Double?, year: Int?) -> AnyPublisher<[MovieResponse], Error> {
        lastSearchQuery = query
        lastSearchGenre = genre
        lastSearchRating = ratingFrom
        lastSearchYear = year
        return Just(searchMoviesResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getRecommendedMovies(genre: String, userRating: Double) -> AnyPublisher<[MovieResponse], Error> {
        lastGenreRequested = genre
        lastRatingRequested = userRating
        return Just(recommendedMoviesResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies() -> AnyPublisher<[MovieResponse], Error> {
        return Just(popularMoviesResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getUserStats() -> UserStats {
        return mockUserStats
    }
    
    func updateUserStats(movie: Movie) {
        mockUserStats.totalWatchedMovieCount += 1
        mockUserStats.totalWatchHours += Double(movie.runtimeMinutes) / 60.0
        
        // Update genre distribution
        var genreDistribution = mockUserStats.genreDistribution ?? [:]
        if let genres = movie.genres {
            for genre in genres {
                let currentCount = genreDistribution[genre] ?? 0
                genreDistribution[genre] = currentCount + 1
            }
        }
        mockUserStats.genreDistribution = genreDistribution
    }
    
    func getUserFavoriteGenreAndRating() -> (genre: String, rating: Double) {
        return favoriteGenreAndRating
    }
    
    func saveContext() {
        // No-op in mock
    }
    
    func getMovie(id: String) -> AnyPublisher<MovieResponse, Error> {
        if let mockMovie = mockMovie {
            return Just(mockMovie)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let movie = mockMovies.first(where: { $0.id == id }) {
            let response = MovieResponse(
                id: movie.id,
                url: nil,
                primaryTitle: movie.primaryTitle,
                originalTitle: nil,
                type: "movie",
                description: nil,
                primaryImage: nil,
                trailer: nil,
                contentRating: nil,
                isAdult: false,
                releaseDate: nil,
                startYear: 2023,
                endYear: nil,
                runtimeMinutes: Int(movie.runtimeMinutes),
                genres: movie.genres,
                interests: nil,
                countriesOfOrigin: nil,
                spokenLanguages: nil,
                averageRating: movie.averageRating,
                numVotes: Int(movie.numVotes)
            )
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "MockError", code: 404, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
}

// Mock model classes
class MockPlaylist: Playlist {
    var mockId: UUID = UUID()
    var mockName: String = ""
    var mockIsDefault: Bool = false
    var mockMovies: [Movie] = []
    
    // This cannot work because NSManagedObject requires entity and context
    // Instead, we'll create a different approach
    
    convenience init(id: UUID, name: String, isDefault: Bool) {
        // Create a temporary entity description
        let entity = NSEntityDescription()
        entity.name = "Playlist"
        entity.managedObjectClassName = NSStringFromClass(Playlist.self)
        
        // Call the designated initializer
        self.init(entity: entity, insertInto: nil)
        
        // Set our properties
        self.mockId = id
        self.mockName = name
        self.mockIsDefault = isDefault
    }
    
    override required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override var id: UUID {
        get { return mockId }
        set { }
    }
    
    override var name: String {
        get { return mockName }
        set { }
    }
    
    override var isDefault: Bool {
        get { return mockIsDefault }
        set { }
    }
    
    override var moviesArray: [Movie] {
        return mockMovies
    }
}

class MockMovie: Movie {
    var mockId: String = ""
    var mockTitle: String = ""
    var mockIsCompleted: Bool = false
    var mockRuntimeMinutes: Int32 = 90
    var mockAverageRating: Double = 7.0
    var mockGenres: [String] = ["Action", "Drama"]
    var mockNumVotes: Int32 = 1000
    
    convenience init(id: String, title: String, isCompleted: Bool) {
        let entity = NSEntityDescription()
        entity.name = "Movie"
        entity.managedObjectClassName = NSStringFromClass(Movie.self)
        
        self.init(entity: entity, insertInto: nil)
        
        self.mockId = id
        self.mockTitle = title
        self.mockIsCompleted = isCompleted
    }
    
    override required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override var id: String {
        get { return mockId }
        set { }
    }
    
    override var primaryTitle: String {
        get { return mockTitle }
        set { }
    }
    
    override var isCompleted: Bool {
        get { return mockIsCompleted }
        set { mockIsCompleted = newValue }
    }
    
    override var runtimeMinutes: Int32 {
        get { return mockRuntimeMinutes }
        set { mockRuntimeMinutes = newValue }
    }
    
    override var averageRating: Double {
        get { return mockAverageRating }
        set { mockAverageRating = newValue }
    }
    
    override var genres: [String]? {
        get { return mockGenres }
        set { if let newValue = newValue { mockGenres = newValue } }
    }
    
    override var numVotes: Int32 {
        get { return mockNumVotes }
        set { mockNumVotes = newValue }
    }
}

class MockUserStats: UserStats {
    var mockTotalWatchedMovieCount: Int32 = 0
    var mockTotalWatchHours: Double = 0
    var mockAverageRating: Double = 0
    var mockFavoriteGenre: String? = nil
    var mockGenreDistribution: [String: Int]? = [:]
    
    override var totalWatchedMovieCount: Int32 {
        get { return mockTotalWatchedMovieCount }
        set { mockTotalWatchedMovieCount = newValue }
    }
    
    override var totalWatchHours: Double {
        get { return mockTotalWatchHours }
        set { mockTotalWatchHours = newValue }
    }
    
    override var averageRating: Double {
        get { return mockAverageRating }
        set { mockAverageRating = newValue }
    }
    
    override var favoriteGenre: String? {
        get { return mockFavoriteGenre }
        set { mockFavoriteGenre = newValue }
    }
    
    override var genreDistribution: [String: Int]? {
        get { return mockGenreDistribution }
        set { mockGenreDistribution = newValue }
    }
}
