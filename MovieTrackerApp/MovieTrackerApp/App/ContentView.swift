//
//  ContentView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//


import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var myCinemaViewModel = MyCinemaViewModel()
    @StateObject private var discoverViewModel = DiscoverViewModel()
    @StateObject private var insightsViewModel = InsightsViewModel()
    
    var body: some View {
        TabView {
            MyCinemaView(viewModel: myCinemaViewModel)
                .tabItem {
                    Label("My Cinema", systemImage: "film")
                }
            
            DiscoverView(viewModel: discoverViewModel)
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
            
            InsightsView(viewModel: insightsViewModel)
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
//        .onAppear {
//            // Initialize Core Data with default playlists if needed
//       //     PersistenceController.shared.createInitialData()
//        }
    }
}
