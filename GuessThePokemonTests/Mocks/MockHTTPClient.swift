//
//  MockHTTPClient.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon


final class MockHTTPClient: HTTPRequestDispatcher {
    var mockResponseData: Data?
    var mockResponseError: HTTP.ApiError?

    func execute(request: HTTP.Request<Data>) -> AnyPublisher<Data, HTTP.ApiError> {
        if let error = mockResponseError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let data = mockResponseData {
            return Just(data)
                .setFailureType(to: HTTP.ApiError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: HTTP.ApiError.invalidResponse).eraseToAnyPublisher()
    }

    func execute<Response: Decodable>(request: HTTP.Request<Response>) -> AnyPublisher<Response, HTTP.ApiError> {
        if let error = mockResponseError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let data = mockResponseData {
            do {
                let decodedResponse = try request.decoder.decode(Response.self, from: data)
                return Just(decodedResponse)
                    .setFailureType(to: HTTP.ApiError.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: HTTP.ApiError.decodingError("")).eraseToAnyPublisher()
            }
        }
        return Fail(error: HTTP.ApiError.invalidResponse).eraseToAnyPublisher()
    }
}
