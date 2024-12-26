//
//  Pagination.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

/// Pagination value type for creating paginated requests
class Pagination: CustomStringConvertible {
    var limit: Int
    var offset: Int
    let maxCount: Int

    init(limit: Int = 50, offset: Int = 0, maxCount: Int = 150) {
        self.limit = limit
        self.offset = offset
        self.maxCount = maxCount
    }

    var hasNextPage: Bool {
        print("hasNextPage: \(offset < maxCount)")
        return offset < maxCount
    }

    func nextPage() {
        let remainingItems = maxCount - offset
        print("remainingItems: \(remainingItems)")
        if remainingItems < limit {
            limit = remainingItems
            print("final limit: \(limit)")
        }
        print("offset: \(offset)")
    }
    
    var description: String {
        "Pagination(limit: \(limit), offset: \(offset) ?? undefined, maxCount: \(maxCount))"
    }
}
