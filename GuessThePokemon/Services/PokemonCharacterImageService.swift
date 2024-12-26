//
//  PokemonCharacterImageService.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 25/12/2024.
//

import Combine
import SwiftUI
import Foundation

/// A protocol for providing services to fetch Pokémon character images. Conforms to `BaseService`, inheriting the HTTP client dependency.
protocol PokemonCharacterImageServiceProviding: BaseService {
        
    func fetchPokemonCharacterImage(characters: [PokemonCharacterDetail]) -> AnyPublisher<[(Data, URL?)], HTTP.ApiError>
}

struct PokemonCharacterImageService: PokemonCharacterImageServiceProviding {
    
    let httpClient: HTTPRequestDispatcher
        
    init(httpClient: HTTPRequestDispatcher) {
        self.httpClient = httpClient
    }
    
    func fetchPokemonCharacterImage(characters: [PokemonCharacterDetail]) -> AnyPublisher<[(Data, URL?)], HTTP.ApiError> {
        let requests = characters.map { character in
            let endpoint = PokemonChracterImageEndpoint(pokemonCharacter: character)
            return HTTP.Request<Data>(endpoint: endpoint)
        }
        return Publishers.Sequence(sequence: requests)
            .flatMap { request in
                return httpClient.execute(request: request)
                    .map { data in
                        return (data, try? request.endpoint.asURLRequest().url)
                    }
                    .eraseToAnyPublisher()
            }
            .collect()
            .eraseToAnyPublisher()
            
    }
}


struct PokemonCharacterImageServiceStub: PokemonCharacterImageServiceProviding {
    
    var httpClient: any HTTPRequestDispatcher = HTTPClient(urlSession: URLSession.shared)
    
    func fetchPokemonCharacterImage(characters: [PokemonCharacterDetail]) -> AnyPublisher<[(Data, URL?)], HTTP.ApiError> {
        return Just([(Data(), URL(string: "dummyUrl"))])
            .setFailureType(to: HTTP.ApiError.self)
            .eraseToAnyPublisher()
    }
}
