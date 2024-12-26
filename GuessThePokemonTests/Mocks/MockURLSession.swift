//
//  MockURLSession.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import Combine
import Foundation
@testable import GuessThePokemon

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: URLError?
    
    func dataTaskPublisherForRequest(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let data = mockData, let response = mockResponse {
            return Just((data: data, response: response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
    }
}
