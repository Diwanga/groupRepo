//
//  PersistenceController.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "MovieTrackerApp")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error.localizedDescription)")
            }
        }
        
        // Merge policy to handle conflicts
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods for Default Data
    
    func createInitialData() {
        let context = container.viewContext
        
        // Check if default playlists exist
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDefault == %@", NSNumber(value: true))
        
        do {
            let existingPlaylists = try context.fetch(fetchRequest)
            if existingPlaylists.isEmpty {
                createDefaultPlaylists()
            }
        } catch {
            print("Error checking for default playlists: \(error)")
        }
        
        // Check if user stats exist
        let statsFetchRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        
        do {
            let existingStats = try context.fetch(statsFetchRequest)
            if existingStats.isEmpty {
                createInitialUserStats()
            }
        } catch {
            print("Error checking for user stats: \(error)")
        }
        
        save()
    }
    
    private func createDefaultPlaylists() {
        let context = container.viewContext
        
        // Create "Completed" playlist
        let completedPlaylist = Playlist(context: context)
        completedPlaylist.id = UUID()
        completedPlaylist.name = "Completed"
        completedPlaylist.isDefault = true
        
        // Create "Watch List" playlist
        let watchListPlaylist = Playlist(context: context)
        watchListPlaylist.id = UUID()
        watchListPlaylist.name = "Watch List"
        watchListPlaylist.isDefault = true
        
        do {
            try context.save()
            print("Default playlists saved successfully")
        } catch {
            print("Failed to save default playlists: \(error)")
        }
    }
    
    private func createInitialUserStats() {
        let context = container.viewContext
        
        let userStats = UserStats(context: context)
        userStats.totalWatchedMovieCount = 0
        userStats.totalWatchHours = 0
        userStats.averageRating = 0
        userStats.genreDistribution = [:]
    }
}
