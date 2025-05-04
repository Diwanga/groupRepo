//
//  MovieTrackerApp.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI

@main
struct MovieTrackerApp: App {
    private let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onAppear {
                    //Create initial data
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Create default playlists if needed
        persistenceController.createInitialData()
    }
    
    private func registerTransformers() {
        // Register value transformers for arrays and dictionaries
//        ArrayTransformer.register()
//        DictionaryTransformer.register()
    }
}
