@testable import VaultOfWonders
import XCTest

@MainActor
final class CollectionViewModelTests: XCTestCase {
    let commune = allRarities[0]
    let rare = allRarities[1]
    let mythique = allRarities[4]

    func testCollectionIsEmptyWithEmptyStore() {
        let viewModel = CollectionViewModel(store: InMemoryCollectionStore())

        XCTAssertEqual(viewModel.counts, [:])
        XCTAssertEqual(viewModel.count(for: commune), 0)
    }

    func testCollectionLoadsCountsFromStore() {
        let store = InMemoryCollectionStore(initialCounts: ["Rare": 4])
        let viewModel = CollectionViewModel(store: store)

        XCTAssertEqual(viewModel.count(for: rare), 4)
    }

    func testAddCountsEachCard() {
        let viewModel = CollectionViewModel(store: InMemoryCollectionStore())

        viewModel.add(cards: [commune, commune, rare])

        XCTAssertEqual(viewModel.count(for: commune), 2)
        XCTAssertEqual(viewModel.count(for: rare), 1)
        XCTAssertEqual(viewModel.count(for: mythique), 0)
    }

    func testAddCumulatesWithPreviousCards() {
        let viewModel = CollectionViewModel(store: InMemoryCollectionStore())

        viewModel.add(cards: [commune])
        viewModel.add(cards: [commune, mythique])

        XCTAssertEqual(viewModel.count(for: commune), 2)
        XCTAssertEqual(viewModel.count(for: mythique), 1)
    }

    func testAddSavesCountsToStore() {
        let store = InMemoryCollectionStore()
        let viewModel = CollectionViewModel(store: store)

        viewModel.add(cards: [rare, rare])

        XCTAssertEqual(store.load(), ["Rare": 2])
    }

    func testCollectionIsRestoredAfterRelaunch() {
        let store = InMemoryCollectionStore()
        let firstLaunch = CollectionViewModel(store: store)
        firstLaunch.add(cards: [commune, mythique])

        let secondLaunch = CollectionViewModel(store: store)

        XCTAssertEqual(secondLaunch.count(for: commune), 1)
        XCTAssertEqual(secondLaunch.count(for: mythique), 1)
    }
}
