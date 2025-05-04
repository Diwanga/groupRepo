//
//  ErrorView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                retryAction()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

