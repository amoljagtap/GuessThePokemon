//
//  ThemeManager.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var theme: ThemeProtocol
    
    init(theme: ThemeProtocol) {
        self.theme = theme
    }
}
