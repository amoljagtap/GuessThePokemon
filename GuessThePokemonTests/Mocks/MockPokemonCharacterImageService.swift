//
//  MockPokemonCharacterImageService.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon

final class MockPokemonCharacterImageService: PokemonCharacterImageServiceProviding {
    var httpClient: HTTPRequestDispatcher = HTTPClient()
    
    func fetchPokemonCharacterImage(characters: [PokemonCharacterDetail]) -> AnyPublisher<[(Data, URL?)], HTTP.ApiError> {
        let mockImages = characters.map { (Data(), URL(string: $0.frontDefault ?? "")) }
        return Just(mockImages)
            .setFailureType(to: HTTP.ApiError.self)
            .eraseToAnyPublisher()
    }
}
