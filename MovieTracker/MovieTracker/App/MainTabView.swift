//
//  MainTabView.shift.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MyCinemaView()
                .tabItem {
                    Label("My Cinema", systemImage: "film")
                }
            
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }
        }
    }
}
#Preview {
    MainTabView()
}
