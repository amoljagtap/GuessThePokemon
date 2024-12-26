//
//  GameOverView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

struct GameOverView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20){
            Text("Game Over")
                .font(.largeTitle)
                .foregroundStyle(themeManager.theme.blackTextColor)
            ButtonView(name: "Start New Game", action: action)
                .frame(width: 200, height: 45)
                .padding()
                .buttonStyle(.borderedProminent)
        }
    }
}
