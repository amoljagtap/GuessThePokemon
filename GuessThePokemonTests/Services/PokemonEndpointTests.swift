//
//  PokemonEndpointTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
@testable import GuessThePokemon

final class PokemonEndpointTests: XCTestCase {
    
    func testPokemonEndpoint_withPokemonPath() {
        let expectedURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0")!
        let endpoint = PokemonEndpoint.pokemon(limit: 100, offset: 0)
        let actualURL = try? endpoint.asURLRequest().url
        XCTAssertTrue(areURLsEqual(actualURL, expectedURL))
    }
    
    func testPokemonEndpoint_withPokemonCharacterNamePath() {
        let endpoint = PokemonEndpoint.pokemonCharacter(name: "pickachu")
        XCTAssertEqual(try? endpoint.asURLRequest().url, URL(string: "https://pokeapi.co/api/v2/pokemon/pickachu"))
    }
    
    private func areURLsEqual(_ url1: URL?, _ url2: URL?) -> Bool {
        guard let url1 = url1, let url2 = url2 else { return false }
        guard url1.scheme == url2.scheme,
              url1.host == url2.host,
              url1.path == url2.path else { return false }
        let queryItems1 = URLComponents(url: url1, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let queryItems2 = URLComponents(url: url2, resolvingAgainstBaseURL: false)?.queryItems ?? []
        return Set(queryItems1) == Set(queryItems2)
    }
}
