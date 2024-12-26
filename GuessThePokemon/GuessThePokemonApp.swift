//
//  GuessThePokemonApp.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

@main
struct GuessThePokemonApp: App {
    var isUnitTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var themeManager = ThemeManager(
        theme: SystemTheme()
    )
    
    private var serviceFactory: ServiceProviding = ServiceFactory.shared
    
    var body: some Scene {
        WindowGroup("Pokemon") {
            if !isUnitTesting {
                GamePlayView(
                    viewModel: PokemonGameViewModel(
                        pokemonService: serviceFactory.pokemonService(),
                        pokemonCharacterImageService: serviceFactory.pokemonCharacterImageService()
                    )
                ).environmentObject(themeManager)
            } else {
                EmptyView()
            }
        }
    }
}
