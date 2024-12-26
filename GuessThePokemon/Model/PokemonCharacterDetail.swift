//
//  PokemonCharacterDetail.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

/// Codable PokemonCharacterDetail value type returns pokemon name and image url
struct PokemonCharacterDetail: Codable, Equatable, ModelIdentifiable {
    let name: String
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case sprites
    }
    
    enum SpritesCodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let spritesContainer = try container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        frontDefault = try spritesContainer.decodeIfPresent(String.self, forKey: .frontDefault)
    }
    
    init(name: String, frontDefault: String?) {
        self.name = name
        self.frontDefault = frontDefault
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var spritesContainer = container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        try spritesContainer.encodeIfPresent(frontDefault, forKey: .frontDefault)
    }
}
