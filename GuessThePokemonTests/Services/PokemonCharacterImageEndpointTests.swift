//
//  PokemonCharacterImageEndpointTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
@testable import GuessThePokemon

final class PokemonCharacterImageEndpointTests: XCTestCase {
    
    func testPokemonCharacterImageEndpoint_withValidURL() {
        let endpoint = PokemonChracterImageEndpoint(pokemonCharacter: PokemonCharacterDetail(name: "pickachu", frontDefault: "https://pokeapi.co/1.png"))
        XCTAssertEqual(try? endpoint.asURLRequest().url, URL(string: "https://pokeapi.co/1.png"))
    }
}
