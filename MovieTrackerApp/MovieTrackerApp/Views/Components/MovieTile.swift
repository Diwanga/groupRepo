//
//  MovieTile.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI

// MARK: - Common Components
//
struct MovieTile: View {
    let movie: MovieItemViewModel
    let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack(alignment: .leading) {
            // Movie Poster
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                  //  .frame(width: width)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .cornerRadius(8)
                
                if let imageURL = movie.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            // Error placeholder
                            Image(systemName: "film")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .foregroundColor(.gray)
                        } else {
                            // Loading placeholder
                            ProgressView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .cornerRadius(8)
                } else {
                    // No image placeholder
                    Image(systemName: "film")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.gray)
                }
            }
            
            // Movie Title
            Text(movie.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.tail)
            
            // Year and Rating
            HStack {
                Text("\(movie.year)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if movie.rating > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", movie.rating))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

//
//struct MovieTile: View {
//    let movie: MovieItemViewModel
//    let aspectRatio: CGFloat = 2/3
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            // Movie Poster - simplified
//            if let imageURL = movie.imageURL {
//                AsyncImage(url: imageURL) { phase in
//                    if let image = phase.image {
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 180)
//                            .clipped()
//                            .cornerRadius(8)
//                    } else if phase.error != nil {
//                        // Error placeholder
//                        Image(systemName: "film")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 180)
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                            .foregroundColor(.gray)
//                    } else {
//                        // Loading placeholder
//                        ProgressView()
//                            .frame(height: 180)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                }
//            } else {
//                // No image placeholder
//                Image(systemName: "film")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 180)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                    .foregroundColor(.gray)
//            }
//            
//            // Movie Title
//            Text(movie.title)
//                .font(.caption)
//                .fontWeight(.medium)
//                .lineLimit(1)
//                .truncationMode(.tail)
//            
//            // Rating only
//            if movie.rating > 0 {
//                HStack(spacing: 2) {
//                    Image(systemName: "star.fill")
//                        .font(.caption2)
//                        .foregroundColor(.yellow)
//                    
//                    Text(String(format: "%.1f", movie.rating))
//                        .font(.caption2)
//                        .foregroundColor(.secondary)
//                }
//            }
//        }
//        .frame(width: 120) // Fixed width to prevent overlap
//        .padding(4) // Reduced padding
//    }
//}
//

//struct MovieTile: View {
//    let movie: MovieItemViewModel
//    let aspectRatio: CGFloat = 2/3
//    let width: CGFloat = 120
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            // Movie Poster
//            ZStack {
//                // Background placeholder always present for consistent sizing
//                Rectangle()
//                    .fill(Color.gray.opacity(0.2))
//                    .frame(width: width)
//                    .aspectRatio(aspectRatio, contentMode: .fit)
//                    .cornerRadius(8)
//                
//                if let imageURL = movie.imageURL {
//                    AsyncImage(url: imageURL) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: width)
//                                .aspectRatio(aspectRatio, contentMode: .fit)
//                                .cornerRadius(8)
//                        } else if phase.error != nil {
//                            // Error placeholder
//                            Image(systemName: "film")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .padding()
//                                .foregroundColor(.gray)
//                                .frame(width: width * 0.5)
//                        } else {
//                            // Loading placeholder
//                            ProgressView()
//                        }
//                    }
//                } else {
//                    // No image placeholder
//                    Image(systemName: "film")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .padding()
//                        .foregroundColor(.gray)
//                        .frame(width: width * 0.5)
//                }
//            }
//            .frame(width: width)
//            
//            // Movie Title
//            Text(movie.title)
//                .font(.caption)
//                .fontWeight(.medium)
//                .lineLimit(1)
//                .truncationMode(.tail)
//                .frame(width: width, alignment: .leading)
//            
//            // Year and Rating
//            HStack {
//                Text("\(movie.year)")
//                    .font(.caption2)
//                    .foregroundColor(.secondary)
//                
//                Spacer()
//                
//                if movie.rating > 0 {
//                    HStack(spacing: 2) {
//                        Image(systemName: "star.fill")
//                            .font(.caption2)
//                            .foregroundColor(.yellow)
//                        
//                        Text(String(format: "%.1f", movie.rating))
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//            .frame(width: width)
//        }
//        //.frame(width: width)
//        .padding(8)
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
//}


//struct MovieTile: View {
//let movie: MovieItemViewModel
//let width: CGFloat = 120
//let aspectRatio: CGFloat = 2/3
//
//var body: some View {
//    VStack(alignment: .leading, spacing: 8) {
//        // Movie Poster with consistent sizing
//        ZStack {
//            // Background placeholder always present
//            Rectangle()
//                .fill(Color.gray.opacity(0.2))
//                .frame(width: width)
//                .aspectRatio(aspectRatio, contentMode: .fit)
//                .cornerRadius(8)
//            
//            if let imageURL = movie.imageURL {
//                AsyncImage(url: imageURL) { phase in
//                    if let image = phase.image {
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: width)
//                            .aspectRatio(aspectRatio, contentMode: .fit)
//                            .cornerRadius(8)
//                            .clipped()
//                    } else if phase.error != nil {
//                        // Error placeholder
//                        Image(systemName: "film")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: width/2)
//                            .foregroundColor(.gray)
//                    } else {
//                        // Loading placeholder
//                        ProgressView()
//                    }
//                }
//            } else {
//                // No image placeholder
//                Image(systemName: "film")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: width/2)
//                    .foregroundColor(.gray)
//            }
//        }
//        
//        // Movie Title - outside the ZStack
//        Text(movie.title)
//            .font(.system(size: 14, weight: .medium))
//            .foregroundColor(.blue)
//            .lineLimit(1)
//            .truncationMode(.tail)
//            .frame(width: width, alignment: .leading)
//        
//        // Year and Rating
//        HStack {
//            Text("\(movie.year)")
//                .font(.caption2)
//                .foregroundColor(.secondary)
//            
//            Spacer()
//            
//            if movie.rating > 0 {
//                HStack(spacing: 2) {
//                    Image(systemName: "star.fill")
//                        .font(.caption2)
//                        .foregroundColor(.yellow)
//                    
//                    Text(String(format: "%.1f", movie.rating))
//                        .font(.caption2)
//                        .foregroundColor(.secondary)
//                }
//            }
//        }
//        .frame(width: width)
//    }
//    .frame(width: width)
//    .padding(.bottom, 8) // Add padding to the bottom specifically
//}
//}
