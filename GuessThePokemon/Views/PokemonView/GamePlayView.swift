//
//  GamePlayView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

/// A content view displays pokemon game
import SwiftUI

struct GamePlayView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: PokemonGameViewModel
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        NavigationStack {
            GameBackgroundView {
                contentViewBasedOnViewState
                    .animation(.easeInOut, value: viewModel.showAnswer)
            }
            .navigationTitle("Who's That Pokemon?")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadGame()
        }
    }

    /// Returns a content layout based on the view model's state
    @ViewBuilder
    private var contentViewBasedOnViewState: some View {
        switch viewModel.viewState {
        case .loading:
            LoadingView()
        case .gameStarted:
            gameContentView
        case .nextPokemon:
            nextPokemonView
        case .gameOver:
            GameOverView {
                viewModel.startNewGame()
            }
        case .error(let errorMessage):
            RetryMessageView(message: errorMessage) {
                viewModel.loadGame()
            }
        }
    }

    /// Returns the game content view based on the current size class
    @ViewBuilder
    private var gameContentView: some View {
        if sizeClass == .compact {
            VStack(alignment: .center, spacing: 20) {
                scoreView
                pokemonImageView
                pokemonOptionsView
            }
        } else {
            HStack(spacing: 25) {
                VStack(spacing: 20) {
                    scoreView
                    pokemonImageView
                }
                VStack {
                    Spacer()
                        .frame(height: 50)
                    pokemonOptionsView
                }
            }
        }
    }

    /// Scorecard view
    private var scoreView: some View {
        VStack(spacing: 10) {
            Group {
                Text("Remaining Pokémons: \(viewModel.remainingCharacters)")
                Text("Score: \(viewModel.score) / \(viewModel.totalCharactersPerGame)")
            }
            .modifier(HeadlineTextStyle())
        }
    }

    /// Pokémon image view
    private var pokemonImageView: some View {
        CachedImageView(
            imageUrl: viewModel.currentCharacterImageUrl,
            showOriginalImage: $viewModel.showAnswer
        )
        .frame(width: 200, height: 200)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 4)
        )
    }

    /// Pokémon options view
    private var pokemonOptionsView: some View {
        PokemonOptionsView(viewModel: viewModel)
    }
    
    /// Load next character view
    private var nextPokemonView: some View {
        ButtonView(name: "Next Pokemon") {
            viewModel.selectRandomPokemonCharacter()
        }
        .frame(width: 200, height: 50)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    GamePlayView(
        viewModel: PokemonGameViewModel(
            pokemonService: ServiceFactory().pokemonService(),
            pokemonCharacterImageService: ServiceFactory().pokemonCharacterImageService()
        )
    )
    .environmentObject(
        ThemeManager(theme: SystemTheme())
    )
}
