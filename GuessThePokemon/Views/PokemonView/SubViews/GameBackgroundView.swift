//
//  GameBackgroundView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 23/12/2024.
//

import SwiftUI

struct GameBackgroundView<Content: View>: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: themeManager.theme.backgroundGradientColors,
                           startPoint: .top,
                           endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            content
        }
        .frame(maxWidth: .infinity)
    }
}
