import SwiftUI

// Face visible d'une carte : couleur de la rareté, dégradé, icône,
// et un reflet animé pour les raretés spéciales (Légendaire et Mythique).
struct RarityCardView: View {
    let rarity: Rarity

    private let shape = RoundedRectangle(cornerRadius: 12)

    var body: some View {
        shape
            .fill(rarity.color)
            .overlay(
                // Dégradé clair en haut, sombre en bas, pour donner du relief.
                LinearGradient(
                    colors: [.white.opacity(0.35), .clear, .black.opacity(0.25)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Image(systemName: rarity.symbol)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
            )
            .overlay {
                if rarity.isSpecial {
                    ShineEffect()
                }
            }
            .clipShape(shape)
            .overlay(shape.stroke(Color.white.opacity(0.4), lineWidth: 2))
            .shadow(
                color: rarity.color.opacity(rarity.isSpecial ? 0.9 : 0.5),
                radius: rarity.isSpecial ? 16 : 8,
                y: 4
            )
    }
}

// Dos d'une carte, visible tant qu'elle n'est pas retournée.
struct CardBackView: View {
    private let shape = RoundedRectangle(cornerRadius: 12)

    var body: some View {
        shape
            .fill(Color(red: 0.20, green: 0.22, blue: 0.30))
            .overlay(
                Image(systemName: "questionmark")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
            )
            .overlay(shape.stroke(Color.white.opacity(0.4), lineWidth: 2))
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
    }
}

// Carte qui se retourne : dos visible au départ, face visible quand isFaceUp passe à true.
struct FlipCardView: View {
    let rarity: Rarity
    let isFaceUp: Bool

    var body: some View {
        ZStack {
            RarityCardView(rarity: rarity)
                .opacity(isFaceUp ? 1 : 0)

            // Le dos est lui-même retourné, pour ne pas apparaître à l'envers.
            CardBackView()
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        // Une carte spéciale grossit légèrement quand elle est révélée.
        .scaleEffect(isFaceUp && rarity.isSpecial ? 1.08 : 1)
        .animation(.easeInOut(duration: 0.45), value: isFaceUp)
    }
}

// Reflet blanc qui traverse la carte en boucle.
private struct ShineEffect: View {
    @State private var hasCrossed = false

    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [.clear, .white.opacity(0.7), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width * 0.6)
            .rotationEffect(.degrees(20))
            .offset(x: hasCrossed ? geometry.size.width * 1.3 : -geometry.size.width * 0.9)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: false)) {
                hasCrossed = true
            }
        }
    }
}
