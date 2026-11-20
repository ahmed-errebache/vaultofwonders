import SwiftUI

struct ChanceView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Les cartes :")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allRarities) { rarity in
                        VStack(spacing: 10) {
                            StackedCardsView(rarity: rarity)

                            Text(rarity.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("\(rarity.percent)%")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(rarity.color)
                        }
                        .cardTile()
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
