//
//  PokemonCharacterImageServiceTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon 

final class PokemonCharacterImageServiceTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var mockHTTPClient: MockHTTPClient!
    private var service: PokemonCharacterImageService!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockHTTPClient = MockHTTPClient()
        service = PokemonCharacterImageService(httpClient: mockHTTPClient)
    }
    
    override func tearDown() {
        cancellables = nil
        mockHTTPClient = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchPokemonCharacterImage_success() throws {
        let expectation = expectation(description: "Images fetched successfully")
        let characters = [
            PokemonCharacterDetail(name: "Pikachu", frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        ]
        let expectedData = "ImageData".data(using: .utf8)!
        mockHTTPClient.mockResponseData = expectedData
        service.fetchPokemonCharacterImage(characters: characters)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, but received error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { images in
                XCTAssertEqual(images.count, 1)
                XCTAssertEqual(images[0].0, expectedData)
                XCTAssertEqual(images[0].1?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchPokemonCharacterImage_failure() throws {
        let expectation = expectation(description: "Error received")
        let characters = [
            PokemonCharacterDetail(name: "Pikachu", frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        ]
        let expectedError = HTTP.ApiError.badRequest("Bad Request")
        mockHTTPClient.mockResponseError = expectedError
        service.fetchPokemonCharacterImage(characters: characters)
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
