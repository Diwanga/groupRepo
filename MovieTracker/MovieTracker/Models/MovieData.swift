//
//  MovieData.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

struct MovieResponse: Codable {
    let rows: Int
    let numFound: Int
    let results: [MovieData]
    let nextCursorMark: String?
}

struct MovieData: Codable, Identifiable {
    let id: String
    let url: String?
    let primaryTitle: String
    let originalTitle: String?
    let type: String
//    let description: String?
    let primaryImage: String?
    let trailer: String?
    let contentRating: String?
    let isAdult: Bool
    let releaseDate: String?
    let startYear: Int?
    let endYear: Int?
//    let runtimeMinutes: Int?
    let genres: [String]?
    let averageRating: Double?
//    let numVotes: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, url, type, trailer, genres
        case primaryTitle = "primaryTitle"
        case originalTitle = "originalTitle"
//        case description = "description"
        case primaryImage = "primaryImage"
        case contentRating = "contentRating"
        case isAdult = "isAdult"
        case releaseDate = "releaseDate"
        case startYear = "startYear"
        case endYear = "endYear"
//        case runtimeMinutes = "runtimeMinutes"
        case averageRating = "averageRating"
//        case numVotes = "numVotes"
    }
    
    var releaseDateFormatted: Date? {
        guard let releaseDate = releaseDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: releaseDate)
    }
}
