//
//  HTTPClientTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon

final class HTTPClientTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    private var mockURLSession: MockURLSession!
    private var httpClient: HTTPClient!
    
    var mockDataRequest: HTTP.Request<Data> {
        let endpoint = PokemonEndpoint.pokemonCharacter(name: "pickachu")
        return HTTP.Request<Data>(endpoint: endpoint)
    }
    
    var mockDecodableRequest: HTTP.Request<PokemonCharacter> {
        let endpoint = PokemonEndpoint.pokemonCharacter(name: "pickachu")
        return HTTP.Request<PokemonCharacter>(endpoint: endpoint)
    }
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockURLSession = MockURLSession()
        httpClient = HTTPClient(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        cancellables = nil
        mockURLSession = nil
        httpClient = nil
        super.tearDown()
    }
    
    func testExecuteData_Success() throws {
        let expectation = expectation(description: "Data received")
        let expectedData = "test data".data(using: .utf8)!
        mockURLSession.mockData = expectedData
        mockURLSession.mockResponse = mockHttpUrlResponse(statusCode: 200)
        httpClient.execute(request: mockDataRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success, but received error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                XCTAssertEqual(data, expectedData)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testExecuteDecodable_Success() throws {
        let expectation = expectation(description: "Decodable response received")
        let character = PokemonCharacter(name: "pickachu")
        let expectedResponse = try? JSONEncoder().encode(character)
        mockURLSession.mockData = expectedResponse
        mockURLSession.mockResponse = mockHttpUrlResponse(statusCode: 200)
        httpClient.execute<PokemonCharacter>(request: mockDecodableRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    XCTFail("Expected value, but received failure")
                case .finished:
                    break
                }
            }, receiveValue: { pokemon in
                XCTAssertEqual(pokemon, character)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 100)
    }
    
    func testExecuteDecodable_DecodingError() throws {
        let expectation = expectation(description: "Decoding error received")
        let invalidJsonData = "invalid json".data(using: .utf8)!
        mockURLSession.mockData = invalidJsonData
        mockURLSession.mockResponse = mockHttpUrlResponse(statusCode: 200)
        httpClient.execute<PokemonCharacter>(request: mockDecodableRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, HTTP.ApiError.decodingError(error.localizedDescription).localizedDescription)
                    expectation.fulfill()
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testExecute_BadRequest() throws {
        let expectation = expectation(description: "Bad Request error received")
        mockURLSession.mockError = URLError(.badURL)
        httpClient.execute(request: mockDataRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, HTTP.ApiError.unknown(URLError(.badURL)).localizedDescription)
                    expectation.fulfill()
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testExecute_ApiError() throws {
        let expectation = expectation(description: "Api error received")
        mockURLSession.mockData = "data".data(using: .utf8)!
        mockURLSession.mockResponse = mockHttpUrlResponse(statusCode: 500)
        httpClient.execute(request: mockDecodableRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "Received server error 500: API error")
                    expectation.fulfill()
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    
    func mockHttpUrlResponse(statusCode: Int) -> HTTPURLResponse? {
        return HTTPURLResponse(url: URL(string: "https://pokeapi.co")!,
                               statusCode: statusCode,
                               httpVersion: nil,
                               headerFields: nil)
    }
}
