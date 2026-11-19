import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    @EnvironmentObject var tokenVM: TokenViewModel

    var body: some View {
        VStack {
            Text("Vault Of Wonders")
                .font(.largeTitle)
                .bold()
                .padding()

            if !vm.showPopup {
                TokenCounter(text: tokenVM.tokenCountText)

                VideoPlayerView(name: "money", isPlaying: false)
                    .frame(width: 320, height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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
                .padding(.top, 20)

                if !tokenVM.canOpenChest {
                    Text("Il te manque \(tokenVM.chestCost - tokenVM.tokens) jeton(s). Va voir le distributeur !")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 6)
                }
            }

            Spacer()
        }
    }
}
