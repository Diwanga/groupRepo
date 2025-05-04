//
//  PlaylistSelectorView.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import SwiftUI
//
//struct PlaylistSelectorView: View {
//    let playlists: [Playlist]
//    @Binding var selectedPlaylists: Set<UUID>
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(playlists, id: \.id) { playlist in
//                    Button(action: {
//                        if selectedPlaylists.contains(playlist.id) {
//                            selectedPlaylists.remove(playlist.id)
//                        } else {
//                            selectedPlaylists.insert(playlist.id)
//                        }
//                    }) {
//                        HStack {
//                            Text(playlist.name)
//                            
//                            Spacer()
//                            
//                            if selectedPlaylists.contains(playlist.id) {
//                                Image(systemName: "checkmark")
//                                    .foregroundColor(.accentColor)
//                            }
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            .navigationTitle("Select Playlists")
//            .navigationBarItems(trailing: Button("Done") {
//                isPresented = false
//            })
//        }
//    }
//}

struct PlaylistSelectorView: View {
    let playlists: [Playlist]
    @Binding var selectedPlaylists: Set<UUID>
    @Binding var isPresented: Bool
    var onDone: () -> Void  // Add this callback
    
    var body: some View {
        NavigationView {
            List {
                ForEach(playlists, id: \.id) { playlist in
                    Button(action: {
                        if selectedPlaylists.contains(playlist.id) {
                            selectedPlaylists.remove(playlist.id)
                        } else {
                            selectedPlaylists.insert(playlist.id)
                        }
                    }) {
                        HStack {
                            Text(playlist.name)
                            
                            Spacer()
                            
                            if selectedPlaylists.contains(playlist.id) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select Playlists")
            .navigationBarItems(trailing: Button("Done") {
                onDone()  // Call the callback
                isPresented = false
            })
        }
    }
}
