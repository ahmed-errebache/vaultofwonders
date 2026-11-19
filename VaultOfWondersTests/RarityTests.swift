@testable import VaultOfWonders
import XCTest

@MainActor
final class RarityTests: XCTestCase {
    func testPercentsSumTo100() {
        var total = 0
        for rarity in allRarities {
            total += rarity.percent
        }

        XCTAssertEqual(total, 100)
    }

    func testRollsFrom1To50GiveCommune() {
        XCTAssertEqual(rarity(forRoll: 1).name, "Commune")
        XCTAssertEqual(rarity(forRoll: 50).name, "Commune")
    }

    func testRollsFrom51To80GiveRare() {
        XCTAssertEqual(rarity(forRoll: 51).name, "Rare")
        XCTAssertEqual(rarity(forRoll: 80).name, "Rare")
    }

    func testRollsFrom81To95GiveEpique() {
        XCTAssertEqual(rarity(forRoll: 81).name, "Épique")
        XCTAssertEqual(rarity(forRoll: 95).name, "Épique")
    }

    func testRollsFrom96To99GiveLegendaire() {
        XCTAssertEqual(rarity(forRoll: 96).name, "Légendaire")
        XCTAssertEqual(rarity(forRoll: 99).name, "Légendaire")
    }

    func testRoll100GivesMythique() {
        XCTAssertEqual(rarity(forRoll: 100).name, "Mythique")
    }

    func testRollOutOfRangeFallsBackToCommune() {
        XCTAssertEqual(rarity(forRoll: 101).name, "Commune")
    }

    func testRandomDrawerAlwaysReturnsAKnownRarity() {
        let drawer = RandomRarityDrawer()
        let knownNames = allRarities.map { $0.name }

        for _ in 0..<100 {
            XCTAssertTrue(knownNames.contains(drawer.drawRarity().name))
        }
    }

    func testNextRarityAfterCommuneIsRare() {
        XCTAssertEqual(nextRarity(after: allRarities[0])?.name, "Rare")
    }

    func testNextRarityAfterLegendaireIsMythique() {
        XCTAssertEqual(nextRarity(after: allRarities[3])?.name, "Mythique")
    }

    func testMythiqueHasNoNextRarity() {
        XCTAssertNil(nextRarity(after: allRarities[4]))
    }

    func testOnlyLegendaireAndMythiqueAreSpecial() {
        let specialNames = allRarities.filter { $0.isSpecial }.map { $0.name }

        XCTAssertEqual(specialNames, ["Légendaire", "Mythique"])
    }

    func testEveryRarityHasASymbol() {
        for rarity in allRarities {
            XCTAssertFalse(rarity.symbol.isEmpty)
        }
    }
}
