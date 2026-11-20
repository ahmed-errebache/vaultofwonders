import Foundation
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

    // Moment où les cartes apparaissent après l'ouverture du coffre,
    // moment où chaque carte se retourne (en secondes après son apparition),
    // puis moment où le bouton « Recevoir » s'affiche.
    private let cardsAppearDelay: Double
    private let revealDelays: [Double]
    private let buttonDelay: Double

    // Une ouverture de coffre donne une carte par délai de retournement :
    // impossible de désynchroniser le nombre de cartes et le nombre de délais.
    var packSize: Int {
        revealDelays.count
    }

    // Le tirage et les délais sont injectés : l'application utilise le hasard
    // et les durées par défaut, les tests passent un MockRarityDrawer pour
    // choisir les cartes et des délais très courts pour aller vite.
    init(
        drawer: RarityDrawing = RandomRarityDrawer(),
        cardsAppearDelay: Double = 2.0,
        revealDelays: [Double] = [0.5, 1.2, 2.2],
        buttonDelay: Double = 2.9
    ) {
        self.drawer = drawer
        self.cardsAppearDelay = cardsAppearDelay
        self.revealDelays = revealDelays
        self.buttonDelay = buttonDelay
    }

    // Dernière carte retournée, ou nil si aucune ne l'est encore.
    var lastRevealedCard: Rarity? {
        revealedCount > 0 ? drawnCards[revealedCount - 1] : nil
    }

    func isRevealed(index: Int) -> Bool {
        index < revealedCount
    }

    func openPack() {
        drawnCards = (0..<packSize).map { _ in drawer.drawRarity() }
            .sorted { $0.percent > $1.percent }
        revealedCount = 0
        showPopup = true
        DispatchQueue.main.asyncAfter(deadline: .now() + cardsAppearDelay) { [weak self] in
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
            self?.showButton = true
        }
    }
}
