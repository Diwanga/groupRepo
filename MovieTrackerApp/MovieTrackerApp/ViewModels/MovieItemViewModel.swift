//
//  MovieItemViewModel.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import Foundation
import Combine
import SwiftUI
import CoreData

class MovieItemViewModel: Identifiable, ObservableObject {
    let id: String
    let title: String
    let imageURL: URL?
    let year: Int
    let genres: [String]
    let rating: Double
    let runtime: Int
    
    init(movie: MovieResponse) {
        self.id = movie.id
        self.title = movie.primaryTitle
        if let imageURLString = movie.primaryImage, !imageURLString.isEmpty {
            self.imageURL = URL(string: imageURLString)
        } else {
            self.imageURL = nil
        }
        self.year = movie.startYear
        self.genres = movie.genres ?? []
        self.rating = movie.averageRating ?? 0.0
        self.runtime = movie.runtimeMinutes ?? 0
    }
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.primaryTitle
        if let imageURLString = movie.primaryImageURL, !imageURLString.isEmpty {
            self.imageURL = URL(string: imageURLString)
        } else {
            self.imageURL = nil
        }
        self.year = Int(movie.startYear)
        self.genres = movie.genres ?? []
        self.rating = movie.averageRating
        self.runtime = Int(movie.runtimeMinutes)
    }
}
