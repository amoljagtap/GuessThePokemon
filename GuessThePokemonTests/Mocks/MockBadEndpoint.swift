//
//  MockBadEndpoint.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import Foundation
@testable import GuessThePokemon

final class MockBadEndpoint: HTTP.Endpoint {
    
    var throwBadRequestError = false
    
    var apiVersion: String = ""
    
    var path: String { return "" }
    
    var queryParameters: [String : String]? { return [:] }
    
    func asURLRequest() throws -> URLRequest {
        if throwBadRequestError {
            throw HTTP.ApiError.badRequest("bad request")
        }
        return URLRequest(url: URL(string: "https://pokeapi.co")!)
    }
    
}
