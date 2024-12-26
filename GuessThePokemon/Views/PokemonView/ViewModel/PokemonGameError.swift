//
//  PokemonGameError.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

enum PokemonGameError: Error {
  case fetchFailed
    
    var localizedDescription: String {
      switch self {
      case .fetchFailed:
          return "Failed to load Pokemon game data. Please try again later."
      }
    }
}
