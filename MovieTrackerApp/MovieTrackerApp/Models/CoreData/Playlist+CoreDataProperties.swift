//
//  Playlist+CoreDataProperties.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
//

//import Foundation
//import CoreData
//
//
//extension Playlist {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
//        return NSFetchRequest<Playlist>(entityName: "Playlist")
//    }
//
//    @NSManaged public var id: UUID?
//    @NSManaged public var isDefault: Bool
//    @NSManaged public var name: String?
//    @NSManaged public var movies: NSSet?
//
//}



import Foundation
import CoreData

extension Playlist {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var isDefault: Bool
    @NSManaged public var movies: NSSet?
    
//    // Create a computed property to get movies as an array
//    public var moviesArray: [Movie] {
//        let set = movies as? Set<Movie> ?? []
//        return Array(set)
//    }
}


extension Playlist {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}

extension Playlist : Identifiable {

}
