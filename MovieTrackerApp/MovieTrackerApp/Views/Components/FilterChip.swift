//
//  FilterChip.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI


struct FilterChip: View {
    let label: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
    }
}
