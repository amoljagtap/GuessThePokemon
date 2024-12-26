//
//  ModelIdentifiable.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

/// Protocol conforms to Identifiable protocol lprovides a default implementation  for 'id' property
protocol ModelIdentifiable: Identifiable, Hashable {
    var id: UUID { get }
}

extension ModelIdentifiable {
    var id: UUID {
        UUID()
    }
}
