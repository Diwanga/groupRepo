//
//  AddPlaylistView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI

struct AddPlaylistView: View {
    @Binding var isPresented: Bool
    @State private var playlistName = ""
    var onAdd: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Playlist")) {
                    TextField("Playlist Name", text: $playlistName)
                }
            }
            .navigationTitle("Create Playlist")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Add") {
                    if !playlistName.isEmpty {
                        onAdd(playlistName)
                        isPresented = false
                    }
                }
                .disabled(playlistName.isEmpty)
            )
        }
    }
}
