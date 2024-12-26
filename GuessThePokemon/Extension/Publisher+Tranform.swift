//
//  Publisher+Tranform.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 25/12/2024.
//

import Combine
import Foundation

extension Publisher where Output == Data, Failure == Error {
    /// Returns tansformed publisher of type AnyPublisher<(Data, URL), Error>
    /// - Parameter url: URL Object
    /// - Returns: Returns tansformed publisher of type AnyPublisher<(Data, URL), Error>
    func withURL(url: URL) -> AnyPublisher<(Data, URL), Error> {
        return self.map { data in
            (data, url)
        }
        .eraseToAnyPublisher()
    }
}
