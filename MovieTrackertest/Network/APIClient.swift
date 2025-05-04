//
//  APIClient.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidData
    case decodingError
}

protocol APIClientProtocol {
    func fetchMovies(searchQuery: String?, genre: String?, minRating: Double?, completion: @escaping (Result<MovieResponse, APIError>) -> Void)
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    private let baseURL = "https://imdb236.p.rapidapi.com/imdb/search"
    private let apiKey = "b2169401aamshc8679aa36ea5b41p1ddc2djsna2ec088ab22f"
    private let host = "imdb236.p.rapidapi.com"
    
    func fetchMovies(searchQuery: String? = nil, genre: String? = nil, minRating: Double? = nil, completion: @escaping (Result<MovieResponse, APIError>) -> Void) {
        var components = URLComponents(string: baseURL)
        var queryItems = [URLQueryItem(name: "type", value: "movie")]
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: searchQuery))
        }
        
        if let genre = genre {
            queryItems.append(URLQueryItem(name: "genre", value: genre))
        }
        
        if let minRating = minRating {
            queryItems.append(URLQueryItem(name: "averageRatingFrom", value: String(minRating)))
        }
        
        queryItems.append(URLQueryItem(name: "rows", value: "20"))
        queryItems.append(URLQueryItem(name: "sortOrder", value: "DESC"))
        queryItems.append(URLQueryItem(name: "sortField", value: "numVotes"))
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": host
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
