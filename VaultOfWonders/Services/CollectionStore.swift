import Foundation

// Le contrat : « savoir charger et sauvegarder la collection ».
// Le CollectionViewModel ne connaît que ce protocole, pas l'endroit où les données sont stockées.
protocol CollectionStore {
    func load() -> [String: Int]
    func save(_ counts: [String: Int])
}

// Implémentation réelle, utilisée par l'application : sauvegarde sur l'appareil.
struct UserDefaultsCollectionStore: CollectionStore {
    private let key = "collection_counts"

    func load() -> [String: Int] {
        UserDefaults.standard.dictionary(forKey: key) as? [String: Int] ?? [:]
    }

    func save(_ counts: [String: Int]) {
        UserDefaults.standard.set(counts, forKey: key)
    }
}

// Implémentation de test : tout reste en mémoire, rien n'est écrit sur l'appareil.
final class InMemoryCollectionStore: CollectionStore {
    private var storage: [String: Int]

    init(initialCounts: [String: Int] = [:]) {
        storage = initialCounts
    }

    func load() -> [String: Int] {
        storage
    }

    func save(_ counts: [String: Int]) {
        storage = counts
    }
}
