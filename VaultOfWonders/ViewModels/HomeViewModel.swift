import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var showPopup = false
    @Published var showCards = false
    @Published var drawnCards: [Rarity] = []
    @Published var showButton = false

    // Nombre de cartes déjà retournées face visible (elles se retournent une à une).
    @Published private(set) var revealedCount = 0

    private let drawer: RarityDrawing

    // Moment où chaque carte se retourne, en secondes après son apparition,
    // puis moment où le bouton « Recevoir » s'affiche.
    private let revealDelays = [0.5, 1.2, 2.2]
    private let buttonDelay = 2.9

    // Le tirage est injecté : l'application utilise le hasard par défaut,
    // les tests passent un MockRarityDrawer pour choisir les cartes.
    init(drawer: RarityDrawing = RandomRarityDrawer()) {
        self.drawer = drawer
    }

    // Dernière carte retournée, ou nil si aucune ne l'est encore.
    var lastRevealedCard: Rarity? {
        revealedCount > 0 ? drawnCards[revealedCount - 1] : nil
    }

    func isRevealed(index: Int) -> Bool {
        index < revealedCount
    }

    func openPack() {
        drawnCards = (0..<3).map { _ in drawer.drawRarity() }
            .sorted { $0.percent > $1.percent }
        revealedCount = 0
        showPopup = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.startReveal()
        }
    }

    // Retourne la carte suivante, sans jamais dépasser le nombre de cartes tirées.
    func revealNextCard() {
        if revealedCount < drawnCards.count {
            revealedCount += 1
        }
    }

    func collectCards(into collectionVM: CollectionViewModel) {
        collectionVM.add(cards: drawnCards)
        showPopup = false
        showCards = false
        showButton = false
        revealedCount = 0
        drawnCards = []
    }

    // Fait apparaître les cartes, programme leur retournement une à une, puis affiche le bouton.
    private func startReveal() {
        showCards = true
        for delay in revealDelays {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.revealNextCard()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + buttonDelay) { [weak self] in
            withAnimation(.easeIn(duration: 0.3)) {
                self?.showButton = true
            }
        }
    }
}
