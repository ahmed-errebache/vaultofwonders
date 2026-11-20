import SwiftUI

// Écran de connexion et de création de compte.
struct AuthView: View {
    // L'état de connexion vient de AuthManager, créé par la vue parente.
    @ObservedObject var authManager: AuthManager

    // Les champs du formulaire sont locaux à cette vue.
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Vault Of Wonders")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("emailField")

                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("passwordField")

                // Le message n'apparaît que si Firebase a renvoyé une erreur.
                if let errorMessage = authManager.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("authErrorLabel")
                }

                Button {
                    authManager.signIn(email: email, password: password)
                } label: {
                    Text("Se connecter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .accessibilityIdentifier("signInButton")

                Button("Créer un compte") {
                    authManager.signUp(email: email, password: password)
                }
                .accessibilityIdentifier("signUpButton")
            }
            .padding()
        }
    }
}
