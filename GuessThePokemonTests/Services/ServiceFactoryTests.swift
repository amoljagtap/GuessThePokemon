//
//  ServiceFactoryTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//


import XCTest
@testable import GuessThePokemon

final class ServiceFactoryTests: XCTestCase {

    func testPokemonService_returnsCorrectType() {
        let factory = ServiceFactory()
        XCTAssertTrue(factory.pokemonService() is PokemonServiceProviding)
        XCTAssertTrue(factory.pokemonService() is PokemonService)

    }

    func testPokemonCharacterImageService_returnsCorrectType() {
        let factory = ServiceFactory()
        XCTAssertTrue(factory.pokemonCharacterImageService() is PokemonCharacterImageServiceProviding)
        XCTAssertTrue(factory.pokemonCharacterImageService() is PokemonCharacterImageService)
    }
    
    func testStubbedServices() {
        let factory = ServiceFactoryStub()
        XCTAssertTrue(factory.pokemonService() is PokemonServiceStub)
        XCTAssertTrue(factory.pokemonCharacterImageService() is PokemonCharacterImageServiceStub)
    }
}
