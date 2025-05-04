//
//  IMDBSearchResponse.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//


import Foundation
import Combine

// MARK: - API Models

struct IMDBSearchResponse: Codable {
    let rows: Int
    let numFound: Int
    let results: [MovieResponse]
    let nextCursorMark: String?
}
