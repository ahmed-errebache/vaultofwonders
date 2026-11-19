import SwiftUI

struct Rarity: Identifiable {
    let id = UUID()
    let name: String
    let percent: Int
    let color: Color
}

let allRarities: [Rarity] = [
    Rarity(name: "Commune",    percent: 50, color: Color(red: 0.60, green: 0.60, blue: 0.60)),
    Rarity(name: "Rare",       percent: 30, color: Color(red: 0.92, green: 0.18, blue: 0.22)),
    Rarity(name: "Épique",     percent: 15, color: Color(red: 0.60, green: 0.28, blue: 0.90)),
    Rarity(name: "Légendaire", percent:  4, color: Color(red: 0.98, green: 0.62, blue: 0.08)),
    Rarity(name: "Mythique",   percent:  1, color: Color(red: 0.08, green: 0.78, blue: 0.92)),
]

// Règle du tirage, sans hasard : à un nombre de 1 à 100 correspond une rareté.
// 1...50 = Commune, 51...80 = Rare, 81...95 = Épique, 96...99 = Légendaire, 100 = Mythique.
func rarity(forRoll roll: Int) -> Rarity {
    var cumulative = 0
    for rarity in allRarities {
        cumulative += rarity.percent
        if roll <= cumulative { return rarity }
    }
    return allRarities[0]
}
