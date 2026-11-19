import SwiftUI

enum AppTab {
    case home
    case chance
    case machine
    case collection
}

struct TabBarView: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            navItem(tab: .chance,     title: "Chances",     systemImage: "dice.fill")
            navItem(tab: .home,       title: "Accueil",    systemImage: "house.fill")
            navItem(tab: .machine,    title: "Distributeur",    systemImage: "gearshape.2.fill")
            navItem(tab: .collection, title: "Collection", systemImage: "square.stack.fill")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .frame(height: 82)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.14), radius: 18, x: 0, y: 10)
        .padding(.horizontal, 24)
    }

    private func navItem(tab: AppTab, title: String, systemImage: String) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.blue.opacity(0.16))
                            .frame(width: 76, height: 56)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.10))
                            .frame(width: 44, height: 44)
                    }
                    Image(systemName: systemImage)
                        .font(.system(size: isSelected ? 25 : 20, weight: .bold))
                        .foregroundStyle(isSelected ? .blue : .gray)
                }
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TabBarView(selectedTab: .constant(.home))
        .padding()
        .background(Color(.systemGray6))
}
