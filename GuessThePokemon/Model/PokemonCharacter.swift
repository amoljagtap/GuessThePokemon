//
//  PokemonCharacter.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import Foundation

/// Codable PokemonCharacter value type returns pokemon name
struct PokemonCharacter: Codable, Hashable, ModelIdentifiable {
    let name: String
}
