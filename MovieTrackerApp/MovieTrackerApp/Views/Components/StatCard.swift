//
//  StatCard.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
