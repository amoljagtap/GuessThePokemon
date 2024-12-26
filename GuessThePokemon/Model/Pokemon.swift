//
//  Pokemons.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

/// Codable Pokemon value type
struct Pokemon: Codable, ModelIdentifiable {
    var next: String?
    let results: [PokemonCharacter]
}
