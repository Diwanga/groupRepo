//
//  MovieResponse.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

struct MovieResponse: Codable, Identifiable {
    let id: String
    let url: String?
    let primaryTitle: String
    let originalTitle: String?
    let type: String
    let description: String?
    let primaryImage: String?
    let trailer: String?
    let contentRating: String?
    let isAdult: Bool
    let releaseDate: String?
    let startYear: Int
    let endYear: Int? //
    let runtimeMinutes: Int?
    let genres: [String]?
    let interests: [String]?
    let countriesOfOrigin: [String]?
    let spokenLanguages: [String]?
    let averageRating: Double?
    let numVotes: Int?
    
    
    // Add a manual initializer to MovieResponse
    init(id: String, url: String?, primaryTitle: String, originalTitle: String?,
         type: String, description: String?, primaryImage: String?, trailer: String?,
         contentRating: String?, isAdult: Bool, releaseDate: String?, startYear: Int,
         endYear: Int?, runtimeMinutes: Int?, genres: [String]?, interests: [String]?,
         countriesOfOrigin: [String]?, spokenLanguages: [String]?,
         averageRating: Double?, numVotes: Int?) {
        
        self.id = id
        self.url = url
        self.primaryTitle = primaryTitle
        self.originalTitle = originalTitle
        self.type = type
        self.description = description
        self.primaryImage = primaryImage
        self.trailer = trailer
        self.contentRating = contentRating
        self.isAdult = isAdult
        self.releaseDate = releaseDate
        self.startYear = startYear
        self.endYear = endYear
        self.runtimeMinutes = runtimeMinutes
        self.genres = genres
        self.interests = interests
        self.countriesOfOrigin = countriesOfOrigin
        self.spokenLanguages = spokenLanguages
        self.averageRating = averageRating
        self.numVotes = numVotes
    }
    
    // Add this initializer to handle potential nil values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        primaryTitle = try container.decode(String.self, forKey: .primaryTitle)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        primaryImage = try container.decodeIfPresent(String.self, forKey: .primaryImage)
        trailer = try container.decodeIfPresent(String.self, forKey: .trailer)
        contentRating = try container.decodeIfPresent(String.self, forKey: .contentRating)
        isAdult = try container.decode(Bool.self, forKey: .isAdult)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        startYear = try container.decode(Int.self, forKey: .startYear)
        endYear = try container.decodeIfPresent(Int.self, forKey: .endYear)
        runtimeMinutes = try container.decodeIfPresent(Int.self, forKey: .runtimeMinutes) ?? 0
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        interests = try container.decodeIfPresent([String].self, forKey: .interests)
        countriesOfOrigin = try container.decodeIfPresent([String].self, forKey: .countriesOfOrigin)
        spokenLanguages = try container.decodeIfPresent([String].self, forKey: .spokenLanguages)
        averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        numVotes = try container.decodeIfPresent(Int.self, forKey: .numVotes) ?? 0
    }
}
