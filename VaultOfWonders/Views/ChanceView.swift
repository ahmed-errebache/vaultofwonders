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
                        RarityCell(
                            name: rarity.name,
                            percent: rarity.percent,
                            color: rarity.color
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

private struct RarityCell: View {
    let name: String
    let percent: Int
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            StackedCards(color: color)
                .frame(width: 90, height: 72)

            Text(name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)

            Text("\(percent)%")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
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

private struct StackedCards: View {
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.55))
                .frame(width: 46, height: 58)
                .rotationEffect(.degrees(-14))
                .offset(x: -10, y: 5)

            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 46, height: 58)
                .rotationEffect(.degrees(10))
                .offset(x: 8, y: -4)
        }
    }
}
