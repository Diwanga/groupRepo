//
//  MovieAPIService.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import Foundation
import Combine


// MARK: - API Service Protocol

protocol MovieAPIServiceProtocol {
    func searchMovies(query: String?, genre: String?, ratingFrom: Double?, rows: Int, year: Int?) -> AnyPublisher<IMDBSearchResponse, Error>
    func getRecommendedMovies(genre: String, userRating: Double, count: Int) -> AnyPublisher<IMDBSearchResponse, Error>
    func getPopularMovies(count: Int) -> AnyPublisher<IMDBSearchResponse, Error>
    func getMovie(id: String) -> AnyPublisher<MovieResponse, Error>
}

// MARK: - API Service Implementation

class MovieAPIService: MovieAPIServiceProtocol {
    private let baseURL = "https://imdb236.p.rapidapi.com/imdb/search"
    private let apiKey = "b2169401aamshc8679aa36ea5b41p1ddc2djsna2ec088ab22f"
    private let apiHost = "imdb236.p.rapidapi.com"
    
    private let decoder: JSONDecoder
    
    init() {
        self.decoder = JSONDecoder()
    }
    
    func searchMovies(query: String? = nil, genre: String? = nil, ratingFrom: Double? = nil, rows: Int = 10, year: Int? = nil) -> AnyPublisher<IMDBSearchResponse, Error> {
        var urlComponents = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem(name: "type", value: "movie")]
        
        // Add optional parameters
        if let query = query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "originalTitleAutocomplete", value: query))
        }
        
        if let genre = genre, !genre.isEmpty {
            queryItems.append(URLQueryItem(name: "genre", value: genre))
        }
        
        if let ratingFrom = ratingFrom {
            queryItems.append(URLQueryItem(name: "averageRatingFrom", value: String(ratingFrom)))
        }
        
        if let year = year {
            queryItems.append(URLQueryItem(name: "startYearFrom", value: String(year)))
        }
        
        queryItems.append(URLQueryItem(name: "rows", value: String(rows)))
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: IMDBSearchResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getRecommendedMovies(genre: String, userRating: Double, count: Int = 5) -> AnyPublisher<IMDBSearchResponse, Error> {
        var urlComponents = URLComponents(string: baseURL)!
        let queryItems = [
            URLQueryItem(name: "type", value: "movie"),
            URLQueryItem(name: "genre", value: genre),
            URLQueryItem(name: "averageRatingFrom", value:  String(userRating)),
            URLQueryItem(name: "rows", value: String(count)),
            URLQueryItem(name: "sortOrder", value: "ASC"),
            URLQueryItem(name: "sortField", value: "id"),
            URLQueryItem(name: "startYearFrom", value: "2018")
        ]
        
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: IMDBSearchResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies(count: Int = 10) -> AnyPublisher<IMDBSearchResponse, Error> {
        var urlComponents = URLComponents(string: baseURL)!
        let queryItems = [
            URLQueryItem(name: "type", value: "movie"),
            URLQueryItem(name: "genre", value: "Sci-Fi"),
            URLQueryItem(name: "averageRatingFrom", value: "7"),
            URLQueryItem(name: "rows", value: String(count)),
            URLQueryItem(name: "sortOrder", value: "ASC"),
            URLQueryItem(name: "sortField", value: "id"),
            URLQueryItem(name: "startYearFrom", value: "2018")
        ]
        
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: IMDBSearchResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getMovie(id: String) -> AnyPublisher<MovieResponse, Error> {
        let urlString = "https://imdb236.p.rapidapi.com/imdb/\(id)"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
