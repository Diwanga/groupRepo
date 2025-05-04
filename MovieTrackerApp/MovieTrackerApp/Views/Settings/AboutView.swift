//
//  AboutView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI



struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Movie Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Version 1.0")
                    .font(.subheadline)
                
                Divider()
                
                Text("This app was developed as part of an MSc project.")
                    .font(.body)
                
                Text("Built with Swift, SwiftUI, and Core Data.")
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("About")
    }
}
