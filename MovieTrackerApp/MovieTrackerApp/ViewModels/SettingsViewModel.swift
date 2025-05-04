//
//  SettingsViewModel.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//

import Foundation
import Combine
import SwiftUI
import CoreData


class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
}
