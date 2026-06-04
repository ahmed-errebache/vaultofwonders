import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var showPopup = false
    @Published var showCards = false
    @Published var drawnCards: [Rarity] = []
    @Published var showButton = false

    func openPack() {
        drawnCards = (0..<3).map { _ in drawRarity() }
            .sorted { $0.percent > $1.percent }
        showPopup = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showCards = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                withAnimation(.easeIn(duration: 0.3)) {
                    self?.showButton = true
                }
            }
        }
    }

    func collectCards(into collectionVM: CollectionViewModel) {
        collectionVM.add(cards: drawnCards)
        showPopup = false
        showCards = false
        showButton = false
        drawnCards = []
    }
}
