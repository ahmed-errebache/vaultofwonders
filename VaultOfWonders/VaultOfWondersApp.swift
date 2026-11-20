import SwiftUI

@main
struct VaultOfWondersApp: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var tokenVM = TokenViewModel()

    // Les tests UI lancent l'application avec l'argument « --reset » pour
    // repartir à chaque fois d'un état vierge (aucun jeton, collection vide).
    init() {
        if ProcessInfo.processInfo.arguments.contains("--reset") {
            UserDefaultsTokenStore().save(0)
            UserDefaultsCollectionStore().save([:])
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(collectionVM)
                .environmentObject(tokenVM)
        }
    }
}
