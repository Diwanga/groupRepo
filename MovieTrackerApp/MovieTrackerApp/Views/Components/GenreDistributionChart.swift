//
//  GenreDistributionChart.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI
import Charts


struct GenreDistributionChart: View {
    let data: [String: Int]
    
    private var sortedData: [(key: String, value: Int)] {
        return data.sorted { $0.value > $1.value }
    }
    
    private var total: Int {
        return data.values.reduce(0, +)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Genre Distribution")
                .font(.headline)
                .padding(.bottom, 8)
            
            if data.isEmpty {
                Text("No data available yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(sortedData.prefix(5), id: \.key) { genre in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(genre.key)
                                .font(.caption)
                            
                            Spacer()
                            
                            Text("\(genre.value) movies")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: geometry.size.width, height: 8)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(Color.accentColor)
                                    .frame(width: geometry.size.width * CGFloat(genre.value) / CGFloat(total), height: 8)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
