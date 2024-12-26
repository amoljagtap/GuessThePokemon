//
//  URLSessionProtocol.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import Combine
import Foundation

/// A protocol to abstract `URLSession` for better testability and flexibility.
protocol URLSessionProtocol {
    /// Returns a publisher with Output as Data object and Error if any
    /// - Parameter request: URLRequest object
    /// - Returns: Returns a publisher with Output as Data and URLResponse and URLError if any
    func dataTaskPublisherForRequest(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

/// An extension to make `URLSession` conform to the `URLSessionProtocol`.
extension URLSession: URLSessionProtocol {
    func dataTaskPublisherForRequest(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
