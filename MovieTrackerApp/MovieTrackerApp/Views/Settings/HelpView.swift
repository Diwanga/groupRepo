//
//  HelpView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                helpSection(title: "My Cinema Tab", content: """
                    - View your movie collections
                    - Create custom playlists
                    - Mark movies as completed
                    - Get personalized recommendations
                    """)
                
                helpSection(title: "Discover Tab", content: """
                    - Search for movies by title, genre, or rating
                    - Find new films to watch
                    - Add movies to your playlists
                    """)
                
                helpSection(title: "Insights Tab", content: """
                    - See statistics about your watched movies
                    - Track watch hours
                    - View genre distribution
                    """)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Help")
    }
    
    private func helpSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
