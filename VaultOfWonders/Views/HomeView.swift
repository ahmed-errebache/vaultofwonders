import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    @ObservedObject var authManager: AuthManager
    @EnvironmentObject var tokenVM: TokenViewModel

    var body: some View {
        VStack {
            Text("Vault Of Wonders")
                .font(.largeTitle)
                .bold()
                .padding()

            if !vm.showPopup {
                TokenCounter(text: tokenVM.tokenCountText)

                ChestVideoView(isPlaying: false)
                    .frame(width: 320, height: 320)
                    .padding(.top, 20)

                Button {
                    // Le coffre ne s'ouvre que si le paiement a réussi.
                    if tokenVM.payForChest() {
                        vm.openPack()
                    }
                } label: {
                    Text("Ouvrir (\(tokenVM.chestCost) jetons)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(tokenVM.canOpenChest ? Color.orange : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!tokenVM.canOpenChest)
                .accessibilityIdentifier("openChestButton")
                .padding(.top, 20)

                if !tokenVM.canOpenChest {
                    Text("Il te manque \(tokenVM.chestCost - tokenVM.tokens) jeton(s). Va voir le distributeur !")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 6)
                        .accessibilityIdentifier("missingTokensLabel")
                }

                // Compte connecté et déconnexion.
                VStack(spacing: 4) {
                    Text(authManager.user?.email ?? "Utilisateur inconnu")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier("userEmailLabel")

                    Button("Se déconnecter") {
                        authManager.signOut()
                    }
                    .font(.footnote)
                    .accessibilityIdentifier("signOutButton")
                }
                .padding(.top, 20)
            }

            Spacer()
        }
    }
}
