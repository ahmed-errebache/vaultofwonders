import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collectionVM: CollectionViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ma collection :")
                    .font(.title).bold()
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allRarities) { rarity in
                        let count = collectionVM.count(for: rarity)
                        VStack(spacing: 10) {
                            StackedCardsView(rarity: rarity, isActive: count > 0)

                            Text(rarity.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("×\(count)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(count > 0 ? rarity.color : .gray.opacity(0.4))
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
