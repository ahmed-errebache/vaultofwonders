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
}
