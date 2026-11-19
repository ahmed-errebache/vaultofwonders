import SwiftUI

struct MachineView: View {
    @EnvironmentObject var tokenVM: TokenViewModel

    var body: some View {
        VStack(spacing: 28) {
            Text("Distributeur :")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            TokenCounter(text: tokenVM.tokenCountText)

            Spacer()

            Button {
                tokenVM.tapMachine()
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "gearshape.2.fill")
                        .font(.system(size: 72, weight: .bold))
                    Text("+1 jeton")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(width: 220, height: 220)
                .background(Circle().fill(Color.orange))
                .shadow(color: .orange.opacity(0.4), radius: 14, y: 8)
            }
            .buttonStyle(MachineButtonStyle())

            Spacer()
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

// Affiche le nombre de jetons possédés. Utilisé sur la page Machine et sur l'accueil.
struct TokenCounter: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(.orange)
            Text(text)
                .bold()
        }
        .font(.title3)
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

// La machine rétrécit légèrement pendant l'appui, pour donner un retour visuel.
private struct MachineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
