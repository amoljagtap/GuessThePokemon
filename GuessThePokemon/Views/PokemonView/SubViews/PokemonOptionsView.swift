//
//  PokemonOptionsView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

struct PokemonOptionsView: View {
        
    @EnvironmentObject var themeManager: ThemeManager
    
    @ObservedObject var viewModel: PokemonGameViewModel
            
    @State var selectedIndex: Int?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            contentView
        }
    }
    
    private var contentView: some View {
        ForEach(viewModel.options.indices, id: \.self) { index in
            ButtonView(name: viewModel.options[index].name.capitalized) {
                selectedIndex = index
                viewModel.revealAnswer(selectedIndex: index)
            }
            .frame(width: 250, height: 45)
            .disabled(viewModel.showAnswer)
            .background(
                buttonBackgroundColor(for: index)
            )
            .cornerRadius(10)
        }
    }
    
    private func buttonBackgroundColor(for index: Int) -> Color {
        if viewModel.showAnswer && index == viewModel.correctAnswerIndex {
            return .green
        } else if viewModel.showAnswer && index == selectedIndex {
            return .red
        } else {
            return .blue
        }
    }
}
