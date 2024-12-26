//
//  HTTP+NetworkError.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//


extension HTTP {
    /// An enum for HTTP API error with localized description
    enum ApiError: Error {
        case badRequest(String)
        case invalidResponse
        case apiError(status: Int, message: String)
        case decodingError(String)
        case unknown(Error)
        
        var localizedDescription: String {
            switch self {
            case .badRequest(let message):
                return "Connot make request: \(message)"
            case .invalidResponse:
                return "Received invalid response from server"
            case .apiError(status: let status, message: let message):
                return "Received server error \(status): \(message)"
            case .decodingError(let message):
                return "\(message)"
            case .unknown(let error):
                return "Unknown error: \(error.localizedDescription)"
            }
        }
    }
    
    /// A protocol for handling errors
    protocol ErrorHandler {
        func handleError(_ error: Error) -> HTTP.ApiError
    }
    
    /// Default error handler class conforms to ErrorHandler protocol. It transforms Error object into HTTP.ApiError
    class DefaultErrorHandler: ErrorHandler {
        func handleError(_ error: Error) -> HTTP.ApiError {
            if let decodingError = error as? DecodingError {
                return HTTP.ApiError.decodingError(decodingError.localizedDescription)
            } else if let apiError = error as? HTTP.ApiError {
                return apiError
            } else {
                return HTTP.ApiError.unknown(error)
            }
        }
    }
}
