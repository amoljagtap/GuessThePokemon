//
//  BundleExtensionTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
@testable import GuessThePokemon

class BundleExtensionTests: XCTestCase {
    
    func testLoadFileSuccess() {
        let data = try? Bundle.loadFile(fileName: "pokemon", extension: "json")
        XCTAssertNotNil(data, "Data should not be nil for valid file.")
    }

    func testLoadFileFailure() {
        do{
            _ = try Bundle.loadFile(fileName: "invalidFile", extension: "json")
            XCTFail("Expected to throw error for invalid file")
        } catch let error {
            XCTAssertNotNil(error)
        }
    }
    
    func testLoadPokemonJSONSuccess() throws {
        do {
            let pokemon = try Bundle.loadPokemonJSON()
            XCTAssertEqual(pokemon.results.count, 11)
        } catch {
            XCTFail("Failed to load or decode Pokemon JSON: \(error)")
        }
    }
    
    func testLoadPokemonCharacterDetailsJSONSuccess() throws {
        do {
            let details = try Bundle.loadPokemonCharacterDetailsJSON()
            XCTAssertEqual(details.name, "pickachu")
        } catch {
            XCTFail("Failed to load or decode PokemonCharacterDetails JSON: \(error)")
        }
    }

}
