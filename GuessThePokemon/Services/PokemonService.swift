//
//  PokemonService.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 23/12/2024.
//

import Combine
import Foundation

/// A protocol for providing services to fetch Pokémon character list and character details. Conforms to `BaseService`, inheriting the HTTP client dependency.
protocol PokemonServiceProviding: BaseService {
    
    func fetchPokemon(pagination: Pagination) -> AnyPublisher<Pokemon, HTTP.ApiError>
    
    func fetchPokemonCharacterDetails(pokemons: [PokemonCharacter]) -> AnyPublisher<[PokemonCharacterDetail], HTTP.ApiError>
}

struct PokemonService: PokemonServiceProviding {
    
    let httpClient: HTTPRequestDispatcher
    
    var subscribers = Set<AnyCancellable>()
    
    init(httpClient: HTTPRequestDispatcher) {
        self.httpClient = httpClient
    }
    
    func fetchPokemon(pagination: Pagination) -> AnyPublisher<Pokemon, HTTP.ApiError> {
        let endpoint = PokemonEndpoint.pokemon(limit: pagination.limit, offset: pagination.offset)
        return httpClient.execute<Pokemon>(request: HTTP.Request(endpoint: endpoint))
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonCharacterDetails(pokemons: [PokemonCharacter]) -> AnyPublisher<[PokemonCharacterDetail], HTTP.ApiError> {
        
        let requests = pokemons.map { pokemon in
            let endpoint = PokemonEndpoint.pokemonCharacter(name: pokemon.name)
            return HTTP.Request<PokemonCharacterDetail>(endpoint: endpoint)
        }
        
        return Publishers.Sequence(sequence: requests)
            .flatMap { request in
                self.httpClient.execute(request: request)
                    .eraseToAnyPublisher()
            }
            .collect()
            .eraseToAnyPublisher()
    }
}


struct PokemonServiceStub: PokemonServiceProviding {
    
    var httpClient: any HTTPRequestDispatcher = HTTPClient(urlSession: URLSession.shared)
    
    
    func fetchPokemon(pagination: Pagination) -> AnyPublisher<Pokemon, HTTP.ApiError> {
        guard let pokemons = try? Bundle.loadPokemonJSON() else {
            return Fail(
                error: HTTP.ApiError.badRequest("Failed to load pokemons JSON from the main bundle")
            )
            .eraseToAnyPublisher()
        }
        return Just(pokemons)
            .setFailureType(to: HTTP.ApiError.self)
            .eraseToAnyPublisher()
        
    }
    
    func fetchPokemonCharacterDetails(pokemons: [PokemonCharacter]) -> AnyPublisher<[PokemonCharacterDetail], HTTP.ApiError> {
        guard let pokemonCharacterDetail = try? Bundle.loadPokemonCharacterDetailsJSON() else {
            return Fail(
                error: HTTP.ApiError.badRequest("Failed to load pokemonCharacterDetail JSON from the main bundle")
            )
            .eraseToAnyPublisher()
        }
        return Just([pokemonCharacterDetail])
            .setFailureType(to: HTTP.ApiError.self)
            .eraseToAnyPublisher()
    }
}
