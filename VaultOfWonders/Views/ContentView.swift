import SwiftUI

// Point d'entrée de l'interface : choisit entre l'écran de connexion et l'application.
struct ContentView: View {
    // ContentView est propriétaire de AuthManager : il le crée une seule fois
    // (@StateObject) puis le transmet aux vues enfants, qui l'observent.
    @StateObject private var authManager = AuthManager()

    // Les tests UI lancent l'application avec « --skip-auth » pour arriver
    // directement sur l'accueil, sans dépendre du réseau ni d'un compte Firebase.
    private let skipAuth = ProcessInfo.processInfo.arguments.contains("--skip-auth")

    var body: some View {
        Group {
            if authManager.isAuthenticated || skipAuth {
                RootView(authManager: authManager)
            } else {
                AuthView(authManager: authManager)
            }
        }
    }
}
