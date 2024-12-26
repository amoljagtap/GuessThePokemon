//
//  HTTP+Endpoint.swift
//  PokemanGame
//
//  Created by Amol Jagtap on 22/12/2024.
//

import Foundation

extension HTTP {
    
    /// A protocol for defining URLRequest object
    protocol Endpoint {
        var baseURL: String { get }
        var apiVersion: String { get }
        var path: String { get }
        var method: HTTP.Method { get }
        var body: Data? { get }
        var queryParameters: [String: String]? { get }
        var headers: [String: String] { get }        
        func asURLRequest() throws -> URLRequest
    }
    
}

extension HTTP.Endpoint {
    var baseURL: String {
        "https://pokeapi.co"
    }
    
    var method: HTTP.Method {
        HTTP.Method.GET
    }
    
    var body: Data? { return nil }
     
    var headers: [String : String] { return [:] }
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        urlComponents.path = path
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
