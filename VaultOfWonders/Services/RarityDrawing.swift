import Foundation

// Le contrat : « savoir tirer une carte ».
// Le HomeViewModel ne connaît que ce protocole, pas la façon dont la carte est tirée.
protocol RarityDrawing {
    func drawRarity() -> Rarity
}

// Implémentation réelle, utilisée par l'application : tirage au hasard.
struct RandomRarityDrawer: RarityDrawing {
    func drawRarity() -> Rarity {
        rarity(forRoll: Int.random(in: 1...100))
    }
}

// Implémentation de test : renvoie les cartes prévues, dans l'ordre donné.
final class MockRarityDrawer: RarityDrawing {
    private var rarities: [Rarity]

    init(rarities: [Rarity]) {
        self.rarities = rarities
    }

    func drawRarity() -> Rarity {
        if rarities.isEmpty {
            return allRarities[0]
        }
        return rarities.removeFirst()
    }
}
