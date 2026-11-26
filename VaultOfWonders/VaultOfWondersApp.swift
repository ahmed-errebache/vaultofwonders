import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct VaultOfWondersApp: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var tokenVM = TokenViewModel()

    // Les tests UI lancent l'application avec l'argument « --reset » pour
    // repartir à chaque fois d'un état vierge (aucun jeton, collection vide).
    init() {
        FirebaseApp.configure()
        if ProcessInfo.processInfo.arguments.contains("--reset") {
            UserDefaultsTokenStore().save(0)
            UserDefaultsCollectionStore().save([:])
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(collectionVM)
                .environmentObject(tokenVM)
                // Après le choix du compte, Google rouvre l'application avec une URL :
                // on la lui transmet pour terminer la connexion.
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
