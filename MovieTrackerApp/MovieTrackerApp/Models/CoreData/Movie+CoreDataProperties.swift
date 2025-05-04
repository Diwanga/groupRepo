//
//  Movie+CoreDataProperties.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
//

//import Foundation
//import CoreData
//
//
//extension Movie {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
//        return NSFetchRequest<Movie>(entityName: "Movie")
//    }
//
//    @NSManaged public var averageRating: Double
//    @NSManaged public var contentRating: String?
//    @NSManaged public var countriesOfOrigin: NSObject?
//    @NSManaged public var description_text: String?
//    @NSManaged public var endYear: Int32
//    @NSManaged public var genres: NSObject?
//    @NSManaged public var id: String?
//    @NSManaged public var interests: NSObject?
//    @NSManaged public var isAdult: Bool
//    @NSManaged public var isCompleted: Bool
//    @NSManaged public var numVotes: Int32
//    @NSManaged public var originalTitle: String?
//    @NSManaged public var primaryTitle: String?
//    @NSManaged public var releaseDate: String?
//    @NSManaged public var runtimeMinutes: Int32
//    @NSManaged public var spokenLanguages: NSObject?
//    @NSManaged public var startYear: Int32
//    @NSManaged public var trailerURL: String?
//    @NSManaged public var type: String?
//    @NSManaged public var playlists: NSSet?
//
//}



import Foundation
import CoreData

extension Movie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: String
    @NSManaged public var primaryTitle: String
    @NSManaged public var originalTitle: String?
    @NSManaged public var description_text: String?
    @NSManaged public var primaryImageURL: String?
    @NSManaged public var trailerURL: String?
    @NSManaged public var contentRating: String?
    @NSManaged public var isAdult: Bool
    @NSManaged public var releaseDate: String?
    @NSManaged public var startYear: Int32
    @NSManaged public var endYear: Int32
    @NSManaged public var runtimeMinutes: Int32
    @NSManaged public var genres: [String]?
    @NSManaged public var interests: [String]?
    @NSManaged public var countriesOfOrigin: [String]?
    @NSManaged public var spokenLanguages: [String]?
    @NSManaged public var averageRating: Double
    @NSManaged public var numVotes: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var type: String
    
    // Relationships
    @NSManaged public var playlists: NSSet?
}



// MARK: Generated accessors for playlists
extension Movie {

    @objc(addPlaylistsObject:)
    @NSManaged public func addToPlaylists(_ value: Playlist)

    @objc(removePlaylistsObject:)
    @NSManaged public func removeFromPlaylists(_ value: Playlist)

    @objc(addPlaylists:)
    @NSManaged public func addToPlaylists(_ values: NSSet)

    @objc(removePlaylists:)
    @NSManaged public func removeFromPlaylists(_ values: NSSet)

}

extension Movie : Identifiable {

}
