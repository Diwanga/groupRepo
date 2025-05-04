//
//  Extensions.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI
import Combine
import CoreData

//// MARK: - Extensions
//
//extension Movie {
//    func addToPlaylists(_ playlist: Playlist) {
//        var currentPlaylists = self.playlists ?? NSSet()
//        let newPlaylists = currentPlaylists.addingObjects(from: [playlist])
//        self.playlists = newPlaylists
//    }
//    
//    func removeFromPlaylists(_ playlist: Playlist) {
//        let currentPlaylists = self.playlists as? Set<Playlist> ?? []
//        let updatedPlaylists = currentPlaylists.filter { $0 != playlist }
//        self.playlists = NSSet(set: updatedPlaylists)
//    }
//}

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


// MARK: - Core Data Helper Extensions

extension NSSet {
    func toArray<T>(of: T.Type) -> [T] {
        return self.map { $0 as! T }
    }
}

extension NSManagedObjectContext {
    // Fixed version - renamed to fetchSafely to avoid infinite recursion
    func fetchSafely<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            // Use the original fetch method from NSManagedObjectContext
            return try self.fetch(request)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }
    
    func saveIfNeeded() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
