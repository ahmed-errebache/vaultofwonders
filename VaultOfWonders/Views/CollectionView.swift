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
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill((count > 0 ? rarity.color : Color.gray).opacity(0.45))
                                    .frame(width: 46, height: 58)
                                    .rotationEffect(.degrees(-14))
                                    .offset(x: -10, y: 5)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(count > 0 ? rarity.color : Color.gray.opacity(0.3))
                                    .frame(width: 46, height: 58)
                                    .rotationEffect(.degrees(10))
                                    .offset(x: 8, y: -4)
                            }
                            .frame(width: 90, height: 72)

                            Text(rarity.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("×\(count)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(count > 0 ? rarity.color : .gray.opacity(0.4))
                        }
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 24)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}
