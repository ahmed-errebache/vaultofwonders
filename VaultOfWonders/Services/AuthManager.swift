import Foundation
import Combine
import FirebaseAuth

// Centralise toute la logique d'authentification Firebase.
// Les vues observent cet objet et se mettent à jour quand l'état de connexion change.
@MainActor
final class AuthManager: ObservableObject {
    // L'utilisateur Firebase connecté (nil si personne n'est connecté).
    @Published var user: User?

    // Vrai si la connexion a réussi.
    @Published var isAuthenticated = false

    // Le dernier message d'erreur à afficher (nil s'il n'y en a pas).
    @Published var errorMessage: String?

    // Crée un compte avec un email et un mot de passe.
    func signUp(email: String, password: String) {
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                user = result.user
                isAuthenticated = true
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // Connecte un utilisateur existant.
    func signIn(email: String, password: String) {
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                user = result.user
                isAuthenticated = true
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // Déconnecte l'utilisateur. Cette méthode Firebase est synchrone : pas de await.
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            isAuthenticated = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
