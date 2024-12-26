//
//  PokemonGameErrorTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//


import XCTest
@testable import GuessThePokemon

class PokemonGameErrorTests: XCTestCase {
    
    func testPokemonGameErrorDescription() {
        XCTAssertEqual(PokemonGameError.fetchFailed.localizedDescription, "Failed to load Pokemon game data. Please try again later.")
    }
}
