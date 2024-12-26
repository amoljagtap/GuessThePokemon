//
//  HTTP+RequestTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
@testable import GuessThePokemon

final class HTTPRequestTests: XCTestCase {

    func testRequestInitialization_defaultDecoder() {
        let endpoint = PokemonEndpoint.pokemonCharacter(name: "pickachu")
        let request = HTTP.Request<String>(endpoint: endpoint)
        XCTAssertEqual(request.endpoint.path, "/api/v2/pokemon/pickachu")
        XCTAssertTrue(request.decoder is JSONDecoder)
    }
    
    func testRequestEndpointProperty() {
        let endpoint = PokemonEndpoint.pokemonCharacter(name: "pickachu")
        let request = HTTP.Request<String>(endpoint: endpoint)
        XCTAssertEqual(request.endpoint.path, "/api/v2/pokemon/pickachu")
    }
}
