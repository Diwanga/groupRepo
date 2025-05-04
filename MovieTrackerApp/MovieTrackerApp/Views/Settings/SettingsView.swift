//
//  SettingsView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import SwiftUI


// MARK: - Settings View

struct SettingsView: View {
    @Binding var isPresented: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Label("About This App", systemImage: "info.circle")
                    }
                    
                    NavigationLink(destination: HelpView()) {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
