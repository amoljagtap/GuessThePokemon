//
//  ButtonView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

struct ButtonView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var name: String
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(name)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(themeManager.theme.buttonTextColor)
                .animation(.easeIn, value: name)
        }
        .frame(maxWidth: .infinity)
    }
}
