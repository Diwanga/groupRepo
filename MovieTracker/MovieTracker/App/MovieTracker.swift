//
//  MovieTracker.shift.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation
import SwiftUI

@main
struct MovieTrackerApp: App {
    @StateObject private var settings = Settings()
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.context)
                .environmentObject(settings)
                .environmentObject(MovieRepository())
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}

class Settings: ObservableObject {
    @Published var isDarkMode: Bool = false
}

#Preview {
    MainTabView()
        .environmentObject(Settings())
}
