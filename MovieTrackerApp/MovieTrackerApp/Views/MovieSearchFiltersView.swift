//
//  MovieSearchFiltersView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI

struct MovieSearchFiltersView: View {
    @Binding var genre: String?
    @Binding var minRating: Double
    @Binding var yearFrom: Int?
    let availableGenres: [String]
    @Binding var isPresented: Bool
    var onApply: () -> Void
    
    @State private var tempGenre: String?
    @State private var tempMinRating: Double
    @State private var tempYearFrom: String = ""
    
    init(genre: Binding<String?>, minRating: Binding<Double>, yearFrom: Binding<Int?>, availableGenres: [String], isPresented: Binding<Bool>, onApply: @escaping () -> Void) {
        self._genre = genre
        self._minRating = minRating
        self._yearFrom = yearFrom
        self.availableGenres = availableGenres
        self._isPresented = isPresented
        self.onApply = onApply
        
        self._tempGenre = State(initialValue: genre.wrappedValue)
        self._tempMinRating = State(initialValue: minRating.wrappedValue)
        
        if let year = yearFrom.wrappedValue {
            self._tempYearFrom = State(initialValue: String(year))
        } else {
            self._tempYearFrom = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Genre")) {
                    Picker("Select Genre", selection: $tempGenre) {
                        Text("Any Genre").tag(nil as String?)
                        ForEach(availableGenres, id: \.self) { genre in
                            Text(genre).tag(genre as String?)
                        }
                    }
                }
                
                Section(header: Text("Minimum Rating")) {
                    VStack {
                        Slider(value: $tempMinRating, in: 0...10, step: 0.5)
                        
                        HStack {
                            Text("Rating: \(tempMinRating, specifier: "%.1f")+")
                            Spacer()
                            
                            if tempMinRating > 0 {
                                Button("Clear") {
                                    tempMinRating = 0
                                }
                                .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                
                Section(header: Text("Year")) {
                    TextField("Year From (e.g. 2000)", text: $tempYearFrom)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Search Filters")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Apply") {
                    genre = tempGenre
                    minRating = tempMinRating
                    
                    if let yearInt = Int(tempYearFrom) {
                        yearFrom = yearInt
                    } else {
                        yearFrom = nil
                    }
                    
                    onApply()
                    isPresented = false
                }
            )
        }
    }
}
