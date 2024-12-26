//
//  HeadlineTextStyle.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI
struct HeadlineTextStyle: ViewModifier {
    
    @EnvironmentObject var themeManaager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(themeManaager.theme.blackTextColor)
    }
}
