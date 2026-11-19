import SwiftUI
import Combine

@MainActor
final class CollectionViewModel: ObservableObject {
    @Published var counts: [String: Int] = [:]

    // Nombre de cartes identiques à donner pour en obtenir une de la rareté supérieure.
    let exchangeCost: Int

    private let store: CollectionStore

    // Le stockage est injecté : l'application utilise UserDefaults par défaut,
    // les tests passent un InMemoryCollectionStore.
    init(store: CollectionStore = UserDefaultsCollectionStore(), exchangeCost: Int = 5) {
        self.store = store
        self.exchangeCost = exchangeCost
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

    func canExchange(_ rarity: Rarity) -> Bool {
        nextRarity(after: rarity) != nil && count(for: rarity) >= exchangeCost
    }

    // Échange des cartes d'une rareté contre une carte de la rareté supérieure.
    // Renvoie false, sans rien changer, si l'échange est impossible.
    func exchange(_ rarity: Rarity) -> Bool {
        guard canExchange(rarity), let next = nextRarity(after: rarity) else {
            return false
        }
        counts[rarity.name, default: 0] -= exchangeCost
        counts[next.name, default: 0] += 1
        store.save(counts)
        return true
    }
}
