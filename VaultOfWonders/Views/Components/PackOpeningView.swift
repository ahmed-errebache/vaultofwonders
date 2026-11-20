import SwiftUI

struct PackOpeningView: View {
    @ObservedObject var vm: HomeViewModel
    let onCollect: () -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                ChestVideoView(isPlaying: true)
                    .frame(width: 320, height: 300)
                    .padding(.top, 140)

                HStack(spacing: 14) {
                    ForEach(Array(vm.drawnCards.enumerated()), id: \.offset) { i, card in
                        VStack(spacing: 6) {
                            FlipCardView(rarity: card, isFaceUp: vm.isRevealed(index: i))
                                .frame(width: 85, height: 110)
                                .accessibilityIdentifier("packCard\(i)")

                            // Le nom n'apparaît qu'une fois la carte retournée.
                            Text(card.name)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(card.color)
                                .opacity(vm.isRevealed(index: i) ? 1 : 0)
                                .animation(.easeIn(duration: 0.3), value: vm.revealedCount)
                        }
                        .opacity(vm.showCards ? 1 : 0)
                        .offset(
                            x: vm.showCards ? 0 : CGFloat(1 - i) * 99,
                            y: vm.showCards ? 0 : 226
                        )
                        .animation(
                            .easeOut(duration: 0.2)
                            .delay(i < 2 ? Double(i) * 0.7 : 1.7),
                            value: vm.showCards
                        )
                    }
                }
            }
            .frame(width: 320)

            if vm.showButton {
                VStack {
                    Spacer()
                    Button(action: onCollect) {
                        Text("Recevoir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                    .accessibilityIdentifier("collectButton")
                    .padding(.bottom, 60)
                }
            }
        }
        // Le bouton « Recevoir » apparaît en fondu.
        .animation(.easeIn(duration: 0.3), value: vm.showButton)
        // Vibration à chaque carte retournée, plus marquée pour une carte spéciale.
        .sensoryFeedback(trigger: vm.revealedCount) { _, newCount in
            guard newCount > 0, let card = vm.lastRevealedCard else {
                return nil
            }
            return card.isSpecial ? .success : .impact
        }
    }
}
