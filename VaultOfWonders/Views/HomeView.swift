import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel

    var body: some View {
        VStack {
            Text("Vault Of Wonders")
                .font(.largeTitle)
                .bold()
                .padding()

            if !vm.showPopup {
                VideoPlayerView(name: "money", isPlaying: false)
                    .frame(width: 320, height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.top, 20)

                Button {
                    vm.openPack()
                } label: {
                    Text("Ouvrir")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
            }

            Spacer()
        }
    }
}
