//
//  PokemonChracterImageEndpoint.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 25/12/2024.
//

import Foundation

/// Endpoint for downloading pokemon image, initalised with character name
struct PokemonChracterImageEndpoint: HTTP.Endpoint {
    
    let pokemonCharacter: PokemonCharacterDetail
    
    var apiVersion: String { return "" }
    
    var path: String { return "" }
    
    var queryParameters: [String : String]? { return [:] }
    
    func asURLRequest() throws -> URLRequest {
        guard let urlString = pokemonCharacter.frontDefault,
              let url = URL(string: urlString) else {
            throw HTTP.ApiError.badRequest("cannot construct URL using the character urlString: \(pokemonCharacter.frontDefault ?? "")")
        }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }
}
