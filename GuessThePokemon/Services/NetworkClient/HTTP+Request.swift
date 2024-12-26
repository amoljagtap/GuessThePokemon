//
//  HTTP+Request.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//


import Foundation

extension HTTP {
    /// A value type for definig HTTP request  for a given endpoint
    struct Request<Response> {
        let endpoint: HTTP.Endpoint
        let decoder:JSONDecoder

        init(endpoint: HTTP.Endpoint, decoder:JSONDecoder = JSONDecoder()) {
            self.endpoint = endpoint
            self.decoder = decoder
        }
    }
}
