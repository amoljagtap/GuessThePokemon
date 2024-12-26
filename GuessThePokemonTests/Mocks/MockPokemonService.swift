//
//  MockPokemonService.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon

final class MockPokemonService: PokemonServiceProviding {
    var httpClient: HTTPRequestDispatcher = HTTPClient()
    
    var mockPokemon: [PokemonCharacter] = [
        PokemonCharacter(name: "Pikachu"),
        PokemonCharacter(name: "Bulbasaur"),
        PokemonCharacter(name: "Squirtle"),
        PokemonCharacter(name: "Blastoise")
    ]
    var mockPokemonCharDetails: [PokemonCharacterDetail] = [
        PokemonCharacterDetail(name: "Pikachu", frontDefault: "https://pokeapi.co/pikachu.png"),
        PokemonCharacterDetail(name: "Bulbasaur", frontDefault: "https://pokeapi.co/bulbasaur.png"),
        PokemonCharacterDetail(name: "Squirtle", frontDefault: "https://pokeapi.co/squirtle.png"),
        PokemonCharacterDetail(name: "Blastoise", frontDefault: "https://pokeapi.co/blastoise.png")
    ]

    func fetchPokemon(pagination: Pagination) -> AnyPublisher<Pokemon, HTTP.ApiError> {
        let response = Pokemon(results: mockPokemon)
        return Just(response)
            .setFailureType(to: HTTP.ApiError.self)
            .eraseToAnyPublisher()
    }

    func fetchPokemonCharacterDetails(pokemons: [PokemonCharacter]) -> AnyPublisher<[PokemonCharacterDetail], HTTP.ApiError> {
        return Just(mockPokemonCharDetails)
            .setFailureType(to: HTTP.ApiError.self)
            .eraseToAnyPublisher()
    }
}
