import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: CollectionStore
    @State var selectedTab: AppTab = .home
    @State var showPopup: Bool = false
    @State var showCards: Bool = false
    @State var drawnCards: [Rarity] = []
    @State var showButton: Bool = false

    var body: some View {
        ZStack {

            // --- Contenu principal (toujours rendu, flou pendant l'ouverture) ---
            VStack {
                if selectedTab == .home {
                    Text("Vault Of Wonders")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    if !showPopup {
                        VideoPlayerView(name: "money", isPlaying: false)
                            .frame(width: 320, height: 320)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.top, 20)

                        Button {
                            drawnCards = (0..<3).map { _ in drawRarity() }
                                .sorted { $0.percent > $1.percent }
                            showPopup = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showCards = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
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
                        .padding(.top, 20)
                    }

                } else if selectedTab == .chance {
                    ChanceView()
                } else if selectedTab == .collection {
                    CollectionView()
                }

                Spacer()
                Component1(selectedTab: $selectedTab)
            }

            // --- Fond flou pendant l'ouverture ---
            if showPopup {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            // --- Animation d'ouverture au-dessus du flou ---
            if showPopup {
                ZStack {
                    // Coffre + cartes centrés, layout fixe
                    ZStack(alignment: .top) {
                        VideoPlayerView(name: "money", isPlaying: true)
                            .frame(width: 320, height: 300)
                            .padding(.top, 120)

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
                                    .delay(i < 2 ? Double(i) * 0.7 : 1.7),
                                    value: showCards
                                )
                            }
                        }
                    }
                    .frame(width: 320)

                    // Bouton en bas, indépendant du layout coffre/cartes
                    if showButton {
                        VStack {
                            Spacer()
                            Button {
                                store.add(cards: drawnCards)
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
                            .padding(.bottom, 60)
                        }
                    }
                }
            }
        }
    }
}
