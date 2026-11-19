@testable import VaultOfWonders
import XCTest

@MainActor
final class TokenViewModelTests: XCTestCase {
    func testStartsWithZeroTokenWithEmptyStore() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore())

        XCTAssertEqual(viewModel.tokens, 0)
    }

    func testLoadsTokensFromStore() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore(initialTokens: 7))

        XCTAssertEqual(viewModel.tokens, 7)
    }

    func testTapMachineAddsOneToken() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore())

        viewModel.tapMachine()
        viewModel.tapMachine()

        XCTAssertEqual(viewModel.tokens, 2)
    }

    func testTapMachineSavesTokensToStore() {
        let store = InMemoryTokenStore()
        let viewModel = TokenViewModel(store: store)

        viewModel.tapMachine()

        XCTAssertEqual(store.load(), 1)
    }

    func testCannotOpenChestJustBelowCost() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore(initialTokens: 9), chestCost: 10)

        XCTAssertFalse(viewModel.canOpenChest)
    }

    func testCanOpenChestWithExactCost() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore(initialTokens: 10), chestCost: 10)

        XCTAssertTrue(viewModel.canOpenChest)
    }

    func testPayForChestRemovesCost() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore(initialTokens: 12), chestCost: 10)

        let paid = viewModel.payForChest()

        XCTAssertTrue(paid)
        XCTAssertEqual(viewModel.tokens, 2)
    }

    func testPayForChestIsRefusedWithoutEnoughTokens() {
        let viewModel = TokenViewModel(store: InMemoryTokenStore(initialTokens: 9), chestCost: 10)

        let paid = viewModel.payForChest()

        XCTAssertFalse(paid)
        XCTAssertEqual(viewModel.tokens, 9)
    }

    func testPayForChestSavesTokensToStore() {
        let store = InMemoryTokenStore(initialTokens: 10)
        let viewModel = TokenViewModel(store: store, chestCost: 10)

        _ = viewModel.payForChest()

        XCTAssertEqual(store.load(), 0)
    }

    func testTokensAreRestoredAfterRelaunch() {
        let store = InMemoryTokenStore()
        let firstLaunch = TokenViewModel(store: store)
        firstLaunch.tapMachine()
        firstLaunch.tapMachine()
        firstLaunch.tapMachine()

        let secondLaunch = TokenViewModel(store: store)

        XCTAssertEqual(secondLaunch.tokens, 3)
    }

    func testTokenCountTextIsSingularUpToOneToken() {
        XCTAssertEqual(TokenViewModel(store: InMemoryTokenStore(initialTokens: 0)).tokenCountText, "0 jeton")
        XCTAssertEqual(TokenViewModel(store: InMemoryTokenStore(initialTokens: 1)).tokenCountText, "1 jeton")
    }

    func testTokenCountTextIsPluralFromTwoTokens() {
        XCTAssertEqual(TokenViewModel(store: InMemoryTokenStore(initialTokens: 2)).tokenCountText, "2 jetons")
    }
}
