//
//  Array+Random.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

// MARK: - Array Extension
extension Array where Element: Equatable {
    /// Returns a random elements sequence from a given array
    /// - Parameters:
    ///   - count: count of random elements
    ///   - excludedElement: an element that's excluded from a random  sequence
    /// - Returns: An array with random elements by excluding the given element
    func randomElements(count: Int, excluding excludedElement: Element) -> [Element] {
        self.filter { $0 != excludedElement }.shuffled().prefix(count).map { $0 }
    }
}
