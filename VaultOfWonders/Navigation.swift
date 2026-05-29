import SwiftUI

enum AppTab {
    case home
    case chance
    case collection
}

struct Component1: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            navItem(
                tab: .home,
                title: "Accueil",
                systemImage: "house.fill"
            )

            navItem(
                tab: .chance,
                title: "Chance",
                systemImage: "shippingbox.fill"
            )

            navItem(
                tab: .collection,
                title: "Collection",
                systemImage: "rectangle.stack.fill"
            )
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .frame(height: 82)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.14), radius: 18, x: 0, y: 10)
        .padding(.horizontal, 24)
    }

    private func navItem(
        tab: AppTab,
        title: String,
        systemImage: String
    ) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.blue.opacity(0.16))
                            .frame(width: 112, height: 56)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.10))
                            .frame(width: 44, height: 44)
                    }

                    Image(systemName: systemImage)
                        .font(.system(size: isSelected ? 25 : 20, weight: .bold))
                        .foregroundStyle(isSelected ? .blue : .gray)
                        .rotationEffect(tab == .collection ? .degrees(-12) : .degrees(0))
                }

                HStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(isSelected ? .blue : .gray)

                    if isSelected {
                        Circle()
                            .fill(.blue)
                            .frame(width: 7, height: 7)
                            .offset(x: 8, y: -11)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Component1(selectedTab: .constant(.collection))
        .padding()
        .background(Color(.systemGray6))
}
