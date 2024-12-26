//
//  Theme.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

protocol ThemeProtocol {
    var backgroundColor: Color { get }
    var blackTextColor: Color { get }
    var buttonTextColor: Color { get }
    var backgroundGradientColors: [Color] { get }
    var greenTextColor: Color { get }
}

struct SystemTheme: ThemeProtocol {
    
    var backgroundColor: Color {
        Color("viewBackground")
    }
    
    var blackTextColor: Color {
        Color("blackTextColor")
    }
    
    var buttonTextColor: Color {
        Color("buttonTextColor")
    }
    
    var backgroundGradientColors: [Color]  {
        [
            Color("backgroundGradientColorYellow"),
            Color("backgroundGradientColorRed")
        ]
    }
    
    var greenTextColor: Color {
        Color("greenTextColor")
    }
}
