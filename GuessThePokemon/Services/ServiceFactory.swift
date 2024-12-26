//
//  ServiceFactory.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 23/12/2024.
//


import SwiftUI

/// A protocol for providing different types of application services
protocol ServiceProviding {
    /// Retruns a service which conforms to PokemonServiceProviding, responsible for fetching pokemon list and pokemon detail
    /// - Returns: Returns a sevice conforms PokemonServiceProviding
    func pokemonService() -> PokemonServiceProviding
    /// Retruns a service which conforms to PokemonCharacterImageServiceProviding, responsible for fetching pokemon  image
    /// - Returns: Returns a sevice conforms PokemonCharacterImageServiceProviding
    func pokemonCharacterImageService() -> PokemonCharacterImageServiceProviding
}

/// A services factory for building different types of services. Conforms to `ServiceProtocol` for service creation dependency
final class ServiceFactory: ServiceProviding {
    
    static let shared: ServiceProviding = {
       #if DEBUG
        if CommandLine.arguments.contains("ui-testing") {
            return ServiceFactoryStub()
        }
        #endif
        return ServiceFactory()
    }()
    
    /// A shared instance of network facade for executing network requests
    static var httpClient: HTTPRequestDispatcher = HTTPClient()
    
    func pokemonService() -> PokemonServiceProviding {
        return PokemonService(httpClient: Self.httpClient)
    }
    
    func pokemonCharacterImageService() -> PokemonCharacterImageServiceProviding {
        return PokemonCharacterImageService(httpClient: Self.httpClient)
    }
}

/// StubServiceFactory return stub services  for runnign the app with mocked data
final class ServiceFactoryStub: ServiceProviding {
    
    func pokemonService() -> PokemonServiceProviding {
        return PokemonServiceStub()
    }
    
    func pokemonCharacterImageService() -> PokemonCharacterImageServiceProviding {
        return PokemonCharacterImageServiceStub()
    }
}
