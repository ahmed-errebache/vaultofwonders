import SwiftUI
import Combine

@MainActor
final class CollectionViewModel: ObservableObject {
    @Published var counts: [String: Int] = [:]
    private let store: CollectionStore

    // Le stockage est injecté : l'application utilise UserDefaults par défaut,
    // les tests passent un InMemoryCollectionStore.
    init(store: CollectionStore = UserDefaultsCollectionStore()) {
        self.store = store
        counts = store.load()
    }

    func add(cards: [Rarity]) {
        for card in cards {
            counts[card.name, default: 0] += 1
        }
        store.save(counts)
    }

    func count(for rarity: Rarity) -> Int {
        counts[rarity.name, default: 0]
    }
}
