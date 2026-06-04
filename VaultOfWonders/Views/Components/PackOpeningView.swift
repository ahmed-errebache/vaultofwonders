import SwiftUI

struct PackOpeningView: View {
    @ObservedObject var vm: HomeViewModel
    let onCollect: () -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                VideoPlayerView(name: "money", isPlaying: true)
                    .frame(width: 320, height: 300)
                    .padding(.top, 120)

                HStack(spacing: 14) {
                    ForEach(Array(vm.drawnCards.enumerated()), id: \.offset) { i, card in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(card.color)
                                .frame(width: 85, height: 110)
                                .shadow(color: card.color.opacity(0.5), radius: 8, y: 4)
                            Text(card.name)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(card.color)
                        }
                        .opacity(vm.showCards ? 1 : 0)
                        .offset(
                            x: vm.showCards ? 0 : CGFloat(1 - i) * 99,
                            y: vm.showCards ? 0 : 206
                        )
                        .animation(
                            .easeOut(duration: 0.2)
                            .delay(i < 2 ? Double(i) * 0.7 : 1.7),
                            value: vm.showCards
                        )
                    }
                }
            }
            .frame(width: 320)

            if vm.showButton {
                VStack {
                    Spacer()
                    Button(action: onCollect) {
                        Text("Recevoir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 60)
                }
            }
        }
    }
}
