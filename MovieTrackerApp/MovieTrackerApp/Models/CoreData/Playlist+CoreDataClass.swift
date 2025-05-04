//
//  Playlist+CoreDataClass.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
//

import Foundation
import CoreData

@objc(Playlist)
public class Playlist: NSManagedObject {
    // Create a computed property to get movies as an array
    public var moviesArray: [Movie] {
        let set = movies as? Set<Movie> ?? []
        return Array(set)
    }
}
