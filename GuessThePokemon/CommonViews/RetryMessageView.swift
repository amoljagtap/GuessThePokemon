//
//  RetryMessageView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

struct RetryMessageView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let message: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundStyle(themeManager.theme.blackTextColor)
                .font(.title)
            ButtonView(name: "Retry") {
                action()
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
}
