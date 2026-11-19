@testable import VaultOfWonders
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {
    let commune = allRarities[0]
    let rare = allRarities[1]
    let mythique = allRarities[4]

    func testInitialStateShowsNothing() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: []))

        XCTAssertFalse(viewModel.showPopup)
        XCTAssertFalse(viewModel.showCards)
        XCTAssertFalse(viewModel.showButton)
        XCTAssertEqual(viewModel.drawnCards.count, 0)
    }

    func testOpenPackDrawsThreeCards() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [rare, rare, rare]))

        viewModel.openPack()

        XCTAssertEqual(viewModel.drawnCards.map { $0.name }, ["Rare", "Rare", "Rare"])
    }

    func testOpenPackSortsCardsFromMostCommonToRarest() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [mythique, commune, rare]))

        viewModel.openPack()

        XCTAssertEqual(viewModel.drawnCards.map { $0.name }, ["Commune", "Rare", "Mythique"])
    }

    func testOpenPackShowsPopupBeforeCardsAndButton() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, commune, commune]))

        viewModel.openPack()

        XCTAssertTrue(viewModel.showPopup)
        XCTAssertFalse(viewModel.showCards)
        XCTAssertFalse(viewModel.showButton)
    }

    func testCollectCardsAddsDrawnCardsToCollection() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, commune, mythique]))
        let collection = CollectionViewModel(store: InMemoryCollectionStore())
        viewModel.openPack()

        viewModel.collectCards(into: collection)

        XCTAssertEqual(collection.count(for: commune), 2)
        XCTAssertEqual(collection.count(for: mythique), 1)
    }

    func testCollectCardsResetsState() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, rare, mythique]))
        let collection = CollectionViewModel(store: InMemoryCollectionStore())
        viewModel.openPack()

        viewModel.collectCards(into: collection)

        XCTAssertFalse(viewModel.showPopup)
        XCTAssertFalse(viewModel.showCards)
        XCTAssertFalse(viewModel.showButton)
        XCTAssertEqual(viewModel.drawnCards.count, 0)
    }

    // MARK: - Révélation des cartes

    func testNoCardIsRevealedRightAfterOpening() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, rare, mythique]))

        viewModel.openPack()

        XCTAssertEqual(viewModel.revealedCount, 0)
        XCTAssertFalse(viewModel.isRevealed(index: 0))
        XCTAssertNil(viewModel.lastRevealedCard)
    }

    func testRevealNextCardRevealsCardsOneByOne() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, rare, mythique]))
        viewModel.openPack()

        viewModel.revealNextCard()

        XCTAssertTrue(viewModel.isRevealed(index: 0))
        XCTAssertFalse(viewModel.isRevealed(index: 1))
        XCTAssertEqual(viewModel.lastRevealedCard?.name, "Commune")
    }

    func testLastRevealedCardFollowsTheReveal() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, rare, mythique]))
        viewModel.openPack()

        viewModel.revealNextCard()
        viewModel.revealNextCard()
        viewModel.revealNextCard()

        XCTAssertEqual(viewModel.lastRevealedCard?.name, "Mythique")
    }

    func testRevealNextCardNeverGoesPastTheDrawnCards() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, rare, mythique]))
        viewModel.openPack()

        for _ in 0..<10 {
            viewModel.revealNextCard()
        }

        XCTAssertEqual(viewModel.revealedCount, 3)
    }

    func testCollectCardsHidesRevealedCards() {
        let viewModel = HomeViewModel(drawer: MockRarityDrawer(rarities: [commune, rare, mythique]))
        let collection = CollectionViewModel(store: InMemoryCollectionStore())
        viewModel.openPack()
        viewModel.revealNextCard()

        viewModel.collectCards(into: collection)

        XCTAssertEqual(viewModel.revealedCount, 0)
    }
}
