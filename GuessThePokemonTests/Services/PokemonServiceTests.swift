//
//  PokemonServiceTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon

final class PokemonServiceTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    private var mockHTTPClient: MockHTTPClient!
    private var service: PokemonService!
    
    let pagination = Pagination(limit: 20, offset: 0)
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        service = PokemonService(httpClient: mockHTTPClient)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        mockHTTPClient = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchPokemon_success() throws {
        let expectation = expectation(description: "Pokemon fetched successfully")
        let expectedPokemon = Pokemon(results: [PokemonCharacter(name: "Pikachu")])
        mockHTTPClient.mockResponseData = try? JSONEncoder().encode(expectedPokemon)
        service.fetchPokemon(pagination: pagination)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, but received error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { pokemon in
                XCTAssertEqual(pokemon, expectedPokemon)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchPokemon_failure() throws {
        let expectation = expectation(description: "Error received")
        let expectedError = HTTP.ApiError.badRequest("Bad Request")
        mockHTTPClient.mockResponseError = expectedError
        service.fetchPokemon(pagination: pagination)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure, but finished successfully")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchPokemonCharacterDetails_success() throws {
        let expectation = expectation(description: "Character details fetched successfully")
        let pokemons = [
            PokemonCharacter(name: "Pikachu"),
        ]
        let expectedDetails = """
            {
              "name": "Pikachu",
              "sprites": {
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
              }
            }
        """
        mockHTTPClient.mockResponseData = expectedDetails.data(using: .utf8)!
        service.fetchPokemonCharacterDetails(pokemons: pokemons)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, but received error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { details in
                XCTAssertEqual(details, [PokemonCharacterDetail(name: "Pikachu", frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")])
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchPokemonCharacterDetails_failure() throws {
        let expectation = expectation(description: "Error received")
        let pokemons = [PokemonCharacter(name: "Pikachu")]
        let expectedError = HTTP.ApiError.badRequest("Bad Request")
        mockHTTPClient.mockResponseError = expectedError
        service.fetchPokemonCharacterDetails(pokemons: pokemons)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure, but finished successfully")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)
    }
}
