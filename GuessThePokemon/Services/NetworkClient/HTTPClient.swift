//
//  HTTPClient.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import Combine
import Foundation
/// A protocol for executing different types of http requests
protocol HTTPRequestDispatcher {
    /// Execute a HTTP.Request of Data type and returns a publisher with Response Data and HTTP.ApiError if any
    /// - Parameter request: HTTP.Request of Data type
    /// - Returns: Retrurn a publisher where Output is Data and Error mapped to HTTP.ApiError
    func execute(request: HTTP.Request<Data>) -> AnyPublisher<Data, HTTP.ApiError>
    /// Execute a HTTP.Request of Decodable type and returns a publisher with Decodable object and HTTP.ApiError if any
    /// - Parameter request: HTTP.Request of Decodable type
    /// - Returns: Retrurn a publisher where Output is Decodable object and Error mapped to HTTP.ApiError
    func execute<Response: Decodable>(request: HTTP.Request<Response>) -> AnyPublisher<Response, HTTP.ApiError>
}

/// A networking client conforms to HTTPRequestDispatcher, implements a logic for executes HTTP.Requests using URLSession injected during initialisation
final class HTTPClient: HTTPRequestDispatcher {
    private var urlSession: URLSessionProtocol
    private var errorHandler: HTTP.ErrorHandler
    
    init(
        urlSession: URLSessionProtocol = URLSession.shared,
        errorHandler: HTTP.ErrorHandler = HTTP.DefaultErrorHandler()
    ) {
        self.urlSession = urlSession
        self.errorHandler = errorHandler
    }
    
    func execute(
        request: HTTP.Request<Data>
    ) -> AnyPublisher<Data, HTTP.ApiError> {
        do {
            let urlRequest = try request.endpoint.asURLRequest()
            return urlSession.dataTaskPublisherForRequest(urlRequest)
                .tryMap { data, urlResponse in
                    try self.validateResponse(urlResponse, data: data)
                    return data
                }
                .mapError { error in
                    self.errorHandler.handleError(error)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTP.ApiError.badRequest(error.localizedDescription)).eraseToAnyPublisher()
        }
    }
    
    func execute<Response: Decodable>(
        request: HTTP.Request<Response>
    ) -> AnyPublisher<Response, HTTP.ApiError> {
        return execute(request: HTTP.Request(endpoint: request.endpoint, decoder: request.decoder))
            .decode(type: Response.self, decoder: request.decoder)
            .mapError { error in
                self.errorHandler.handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func validateResponse(
        _ urlResponse: URLResponse,
        data: Data
    ) throws {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw HTTP.ApiError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw HTTP.ApiError.apiError(status: httpResponse.statusCode, message: "API error")
        }
    }
}
