import SwiftUI

class CollectionStore: ObservableObject {
    @Published var counts: [String: Int] = [:]
    private let key = "collection_counts"

    init() {
        counts = UserDefaults.standard.dictionary(forKey: key) as? [String: Int] ?? [:]
    }

    func add(cards: [Rarity]) {
        for card in cards {
            counts[card.name, default: 0] += 1
        }
        UserDefaults.standard.set(counts, forKey: key)
    }

    func count(for rarity: Rarity) -> Int {
        counts[rarity.name, default: 0]
    }
}
