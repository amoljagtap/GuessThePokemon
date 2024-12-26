//
//  HTPP+ApiErrorTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
@testable import GuessThePokemon

final class HTTPErrorsTests: XCTestCase {

    func testApiErrorLocalizedDescription_badRequest() {
        let error = HTTP.ApiError.badRequest("Invalid input")
        XCTAssertEqual(error.localizedDescription, "Connot make request: Invalid input")
    }

    func testApiErrorLocalizedDescription_invalidResponse() {
        let error = HTTP.ApiError.invalidResponse
        XCTAssertEqual(error.localizedDescription, "Received invalid response from server")
    }

    func testApiErrorLocalizedDescription_apiError() {
        let error = HTTP.ApiError.apiError(status: 404, message: "Not Found")
        XCTAssertEqual(error.localizedDescription, "Received server error 404: Not Found")
    }

    func testApiErrorLocalizedDescription_decodingError() {
        let error = HTTP.ApiError.decodingError("Failed to parse JSON")
        XCTAssertEqual(error.localizedDescription, "Failed to parse JSON")
    }

    func testApiErrorLocalizedDescription_unknownError() {
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Some unknown error"])
        let error = HTTP.ApiError.unknown(underlyingError)
        XCTAssertEqual(error.localizedDescription, "Unknown error: Some unknown error")
    }

    func testDefaultErrorHandler_decodingError() {
        let decodingError = DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "invalida data"))
        let handler = HTTP.DefaultErrorHandler()
        let handledError = handler.handleError(decodingError)
        XCTAssertEqual(handledError.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
    }
    
    func testDefaultErrorHandler_apiError() {
        let apiError = HTTP.ApiError.apiError(status: 400, message: "Bad Request")
        let handler = HTTP.DefaultErrorHandler()
        let handledError = handler.handleError(apiError)
        XCTAssertEqual(handledError.localizedDescription, "Received server error 400: Bad Request")
    }

    func testDefaultErrorHandler_unknownError() {
        let unknownError = NSError(domain: "UnknownDomain", code: 456, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred"])
        let handler = HTTP.DefaultErrorHandler()
        let handledError = handler.handleError(unknownError)
        XCTAssertEqual(handledError.localizedDescription, "Unknown error: An unknown error occurred")
    }
}
