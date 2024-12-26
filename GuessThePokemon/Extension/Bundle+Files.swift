//
//  Bundle+Files.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import Foundation

extension Bundle {
    
    enum FileError: Error, LocalizedError {
        case fileNotFound
    }
    
    static func loadFile(fileName: String, extension: String) throws -> Data {
        let bundle = Bundle(for: ServiceFactory.self)
        guard let url = bundle.url(forResource: fileName, withExtension: `extension`),
                let data = try? Data(contentsOf: url) else {
            throw FileError.fileNotFound
        }
        return data
    }
    
    static func loadPokemonJSON() throws -> Pokemon {
        do {
            let data = try loadFile(fileName: "pokemon", extension: "json")
            return try JSONDecoder().decode(Pokemon.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            throw error
        }
    }
    
    static func loadPokemonCharacterDetailsJSON() throws -> PokemonCharacterDetail {
        do {
            let data = try loadFile(fileName: "pokemonCharacterDetails", extension: "json")
            return try JSONDecoder().decode(PokemonCharacterDetail.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            throw error
        }
    }
}
