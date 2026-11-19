import Foundation

// Le contrat : « savoir charger et sauvegarder le nombre de jetons ».
// Le TokenViewModel ne connaît que ce protocole, pas l'endroit où les jetons sont stockés.
protocol TokenStore {
    func load() -> Int
    func save(_ tokens: Int)
}

// Implémentation réelle, utilisée par l'application : sauvegarde sur l'appareil.
struct UserDefaultsTokenStore: TokenStore {
    private let key = "token_count"

    func load() -> Int {
        UserDefaults.standard.integer(forKey: key)
    }

    func save(_ tokens: Int) {
        UserDefaults.standard.set(tokens, forKey: key)
    }
}

// Implémentation de test : tout reste en mémoire, rien n'est écrit sur l'appareil.
final class InMemoryTokenStore: TokenStore {
    private var storage: Int

    init(initialTokens: Int = 0) {
        storage = initialTokens
    }

    func load() -> Int {
        storage
    }

    func save(_ tokens: Int) {
        storage = tokens
    }
}
