//
//  Extensions.swift
//  MovieTracker
//
//  Created by Diwanga Amasith on 2025-05-02.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

extension Movie {
    var genresArray: [String] {
        genres as? [String] ?? []
    }
}
