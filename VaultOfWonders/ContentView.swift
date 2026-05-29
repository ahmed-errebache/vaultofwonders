import SwiftUI

struct ContentView: View {
    @State var selectedTab: AppTab = .home
    @State var showPopup: Bool = false
    @State var showCards: Bool = false
    @State var drawnCards: [Rarity] = []
    @State var showButton: Bool = false

    var body: some View {
        ZStack {
            VStack {
                if selectedTab == .home {
                    Text("Vault Of Wonders")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    if !showPopup {
                        // --- État initial ---
                        Button {
                            drawnCards = (0..<3).map { _ in drawRarity() }
                            showPopup = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showCards = true
                                // 0.5s après la fin de la dernière carte (délai 1.4s + durée 0.2s)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                                    withAnimation(.easeIn(duration: 0.3)) {
                                        showButton = true
                                    }
                                }
                            }
                        } label: {
                            Text("Ouvrir")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                            VideoPlayerView(name: "money", isPlaying: false)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .frame(width: 320, height: 320)
                        .padding(.top, 20)

                    } else {
                        // --- État ouvert ---
                        ZStack(alignment: .top) {

                            // Vidéo en bas du ZStack
                            VideoPlayerView(name: "money", isPlaying: true)
                                .frame(width: 320, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.top, 120)

                            // Cartes qui sortent du coffre vers le haut
                            HStack(spacing: 14) {
                                ForEach(Array(drawnCards.enumerated()), id: \.offset) { i, card in
                                    VStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(card.color)
                                            .frame(width: 85, height: 110)
                                            .shadow(color: card.color.opacity(0.5), radius: 8, y: 4)
                                        Text(card.name)
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(card.color)
                                    }
                                    .opacity(showCards ? 1 : 0)
                                    .offset(
                                        x: showCards ? 0 : CGFloat(1 - i) * 99,
                                        y: showCards ? 0 : 206
                                    )
                                    .animation(
                                        .easeOut(duration: 0.2)
                                        .delay(Double(i) * 0.7),
                                        value: showCards
                                    )
                                }
                            }
                        }
                        .frame(width: 320)
                        .padding(.top, 8)

                        if showButton {
                            Button {
                                showPopup = false
                                showCards = false
                                showButton = false
                                drawnCards = []
                            } label: {
                                Text("Recevoir")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 200)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(12)
                            }
                            .padding(.top, 16)
                        }
                    }

                } else if selectedTab == .chance {
                    ChanceView()
                } else if selectedTab == .collection {
                    Text("Collection")
                        .font(.largeTitle).bold().padding()
                }

                Spacer()

                Component1(selectedTab: $selectedTab)
            }
        }
    }
}
