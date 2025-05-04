//
//  PlaylistTile.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-04.
//
import SwiftUI

// New component for playlist tiles
struct PlaylistTile: View {
    let name: String
    let isDefault: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(isDefault ? (name == "Watchlist" ? Color.blue : Color.green) : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                
                if name == "Watch List" {
                    Image(systemName: "list.bullet")
                      //  .font(.title)
                     //   .foregroundColor(.white)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color.blue )
                        .cornerRadius(10)
                } else if name == "Completed" {
                    Image(systemName: "checkmark.seal.fill")
                     //   .font(.title)
                     //   .foregroundColor(.white)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color.green)
                        .cornerRadius(10)
                } else {
                    Image(systemName: "folder")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
            }
            
            Text(name)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}
