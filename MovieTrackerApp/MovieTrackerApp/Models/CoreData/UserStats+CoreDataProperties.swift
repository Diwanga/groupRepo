//
//  UserStats+CoreDataProperties.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
//

import Foundation
import CoreData


//extension UserStats {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStats> {
//        return NSFetchRequest<UserStats>(entityName: "UserStats")
//    }
//
//    @NSManaged public var averageRating: Double
//    @NSManaged public var favoriteGenre: String?
//    @NSManaged public var genreDistribution: NSObject?
//    @NSManaged public var totalWatchedMovieCount: Int32
//    @NSManaged public var totalWatchHours: Double
//
//}

extension UserStats {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStats> {
        return NSFetchRequest<UserStats>(entityName: "UserStats")
    }

    @NSManaged public var totalWatchedMovieCount: Int32
    @NSManaged public var totalWatchHours: Double
    @NSManaged public var averageRating: Double
    @NSManaged public var favoriteGenre: String?
    @NSManaged public var genreDistribution: [String: Int]?
}


extension UserStats : Identifiable {

}
