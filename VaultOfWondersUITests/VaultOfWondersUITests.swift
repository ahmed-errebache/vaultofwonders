//
//  VaultOfWondersUITests.swift
//  VaultOfWondersUITests
//
//  Created by Lucas Charpentier on 20/11/2026.
//

import XCTest

// Les tests UI pilotent la vraie application dans le simulateur, de l'extérieur,
// comme le ferait un utilisateur. Ils tournent dans un processus séparé : impossible
// d'importer les types de l'application, on ne voit que ce qui est à l'écran,
// repéré par les accessibilityIdentifier posés dans les vues.
final class VaultOfWondersUITests: XCTestCase {

    // Le tirage étant aléatoire, les tests ne supposent jamais quelle rareté sort :
    // ils raisonnent sur le total de cartes, toutes raretés confondues.
    private let rarityNames = ["Commune", "Rare", "Épique", "Légendaire", "Mythique"]

    private var app: XCUIApplication!

    @MainActor
    override func setUpWithError() throws {
        // Un échec arrête le test : la suite des étapes n'aurait pas de sens.
        continueAfterFailure = false

        // « --reset » remet les jetons à zéro et vide la collection :
        // chaque test part du même état, quel que soit l'ordre d'exécution.
        // « --skip-auth » saute l'écran de connexion Firebase.
        app = XCUIApplication()
        app.launchArguments = ["--reset", "--skip-auth"]
        app.launch()
    }

    // MARK: - Scénario 1 : état initial

    @MainActor
    func testFreshLaunchStartsWithNoTokenAndChestLocked() throws {
        assertTokenCounterReads("0 jeton")

        let openButton = app.buttons["openChestButton"]
        XCTAssertTrue(openButton.exists)
        XCTAssertFalse(openButton.isEnabled)
        XCTAssertTrue(app.staticTexts["missingTokensLabel"].exists)
    }

    // MARK: - Scénario 2 : le distributeur rapporte un jeton

    @MainActor
    func testTappingMachineEarnsOneToken() throws {
        earnTokens(1)

        assertTokenCounterReads("1 jeton")
    }

    // MARK: - Scénario 3 : le coffre se débloque à 10 jetons

    @MainActor
    func testChestUnlocksAtTenTokens() throws {
        earnTokens(10)
        app.buttons["tab-home"].tap()

        assertTokenCounterReads("10 jetons")
        XCTAssertTrue(app.buttons["openChestButton"].isEnabled)
        XCTAssertFalse(app.staticTexts["missingTokensLabel"].exists)
    }

    // MARK: - Scénario 4 : parcours complet, du distributeur à la collection

    @MainActor
    func testFullChestOpeningFlowAddsThreeCardsToCollection() throws {
        earnTokens(10)
        app.buttons["tab-home"].tap()
        app.buttons["openChestButton"].tap()

        // L'animation d'ouverture dure environ 5 secondes : on attend que le
        // bouton « Recevoir » apparaisse, sans jamais utiliser de sleep arbitraire.
        let collectButton = app.buttons["collectButton"]
        XCTAssertTrue(collectButton.waitForExistence(timeout: 8))
        collectButton.tap()

        // De retour sur l'accueil : les 10 jetons ont été dépensés.
        XCTAssertTrue(app.buttons["openChestButton"].waitForExistence(timeout: 2))
        assertTokenCounterReads("0 jeton")

        // Et la collection contient 3 cartes, quelles que soient les raretés tirées.
        XCTAssertEqual(totalCollectedCards(), 3)
    }

    // MARK: - Scénario 5 : les jetons survivent à un redémarrage

    @MainActor
    func testTokensSurviveARelaunch() throws {
        earnTokens(3)

        // Relance sans « --reset » : l'état sauvegardé doit être conservé.
        app.terminate()
        app.launchArguments = ["--skip-auth"]
        app.launch()

        app.buttons["tab-machine"].tap()
        assertTokenCounterReads("3 jetons")
    }

    // MARK: - Aides

    // Va sur l'onglet distributeur et clique le nombre de fois demandé.
    @MainActor
    private func earnTokens(_ count: Int) {
        app.buttons["tab-machine"].tap()
        let machineButton = app.buttons["machineButton"]
        for _ in 0..<count {
            machineButton.tap()
        }
    }

    // Le compteur de jetons est un élément d'accessibilité combiné : son libellé
    // se termine par le texte affiché. On compare la fin du libellé et non
    // « contient », car « 10 jetons » contient la sous-chaîne « 0 jeton ».
    @MainActor
    private func assertTokenCounterReads(
        _ expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let counter = app.descendants(matching: .any)["tokenCounter"].firstMatch
        XCTAssertTrue(counter.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertTrue(
            counter.label.hasSuffix(expected),
            "Le compteur affiche « \(counter.label) » au lieu de « \(expected) »",
            file: file,
            line: line
        )
    }

    // Ouvre l'onglet collection et additionne les compteurs « ×N » des cinq raretés.
    @MainActor
    private func totalCollectedCards() -> Int {
        app.buttons["tab-collection"].tap()
        return rarityNames
            .map { app.staticTexts["collectionCount-\($0)"].label }
            .compactMap { Int($0.dropFirst()) }  // retire le « × »
            .reduce(0, +)
    }
}
