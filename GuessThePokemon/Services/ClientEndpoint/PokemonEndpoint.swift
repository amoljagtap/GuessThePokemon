//
//  ClientAPI+PokemonEndpoint.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 23/12/2024.
//

import Foundation

/// Enpoint for fetching pokemon data
enum PokemonEndpoint: HTTP.Endpoint {
    // Returns an endpoint with path and query items: "/path?limit=10&offset=0"
    case pokemon(limit: Int?, offset: Int?)
    // Returns an endpoint with path "/pokemon/{name}"
    case pokemonCharacter(name: String)
    
    var queryParameters: [String : String]? {
        switch self {
        case .pokemon(let limit, let offset):
            guard let limit = limit, let offset = offset else { return nil }
            return [
                "limit": "\(limit)",
                "offset": "\(offset)"
            ]
        case .pokemonCharacter(_):
            return nil
        }
    }
    
    var apiVersion: String {
        "api/v2"
    }
    
    var path: String {
        switch self {
        case .pokemon(_, _):
            return "/\(apiVersion)/pokemon"
        case .pokemonCharacter(let name):
            return "/\(apiVersion)/pokemon/\(name)"
        }
    }
}

