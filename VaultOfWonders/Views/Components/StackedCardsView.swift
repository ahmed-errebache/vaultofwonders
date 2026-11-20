import SwiftUI

// Deux cartes empilées aux couleurs d'une rareté.
// Utilisé par l'écran Chances et par l'écran Collection.
// isActive = false dessine les cartes en gris (rareté pas encore obtenue).
struct StackedCardsView: View {
    let rarity: Rarity
    var isActive = true

    private var color: Color {
        isActive ? rarity.color : Color.gray.opacity(0.5)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.5))
                .frame(width: 46, height: 58)
                .rotationEffect(.degrees(-14))
                .offset(x: -10, y: 5)

            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 46, height: 58)
                .overlay(
                    Image(systemName: rarity.symbol)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                )
                .rotationEffect(.degrees(10))
                .offset(x: 8, y: -4)
        }
        .frame(width: 90, height: 72)
    }
}

// Fond commun des cases des écrans Chances et Collection.
// Les couleurs système s'adaptent toutes seules au mode clair et au mode sombre.
extension View {
    func cardTile() -> some View {
        self
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
            )
    }
}
