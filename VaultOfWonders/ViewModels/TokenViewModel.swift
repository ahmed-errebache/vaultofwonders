import SwiftUI
import Combine

@MainActor
final class TokenViewModel: ObservableObject {
    // Les vues peuvent lire le nombre de jetons, mais seul ce ViewModel peut le modifier.
    @Published private(set) var tokens: Int

    // Prix d'un coffre, en jetons.
    let chestCost: Int

    private let store: TokenStore

    // Le stockage est injecté : l'application utilise UserDefaults par défaut,
    // les tests passent un InMemoryTokenStore.
    init(store: TokenStore = UserDefaultsTokenStore(), chestCost: Int = 10) {
        self.store = store
        self.chestCost = chestCost
        tokens = store.load()
    }

    var canOpenChest: Bool {
        tokens >= chestCost
    }

    var tokenCountText: String {
        tokens <= 1 ? "\(tokens) jeton" : "\(tokens) jetons"
    }

    // Un appui sur la machine rapporte un jeton.
    func tapMachine() {
        tokens += 1
        store.save(tokens)
    }

    // Retire le prix d'un coffre. Renvoie false, sans rien retirer, s'il n'y a pas assez de jetons.
    func payForChest() -> Bool {
        guard canOpenChest else {
            return false
        }
        tokens -= chestCost
        store.save(tokens)
        return true
    }
}
