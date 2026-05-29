//
//  BottomBarView.swift
//  VaultOfWonders
//
//  Created by Ahmed Errebache on 29/05/2026.
//


import SwiftUI
enum BottomBarSelectedTab {
    case home, chance, collection
}
struct BottomBar: View {
    @Binding var selectedTab: BottomBarSelectedTab
    
    var body: some View {
        HStack {
            BottomBarButtonView(image: "dice.fill", text: "Chance", isActive: selectedTab == .chance)
                .onTapGesture { selectedTab = .chance }
            Spacer()
            BottomBarButtonView(image: "house.fill", text: "Home", isActive: selectedTab == .home)
                .onTapGesture { selectedTab = .home }
            Spacer()
            BottomBarButtonView(image: "books.vertical.fill", text: "Collection", isActive: selectedTab == .collection)
                .onTapGesture { selectedTab = .collection }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
    }
}
struct BottomBarButtonView: View {
    var image: String
    var text: String
    var isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: image)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isActive ? .purple : .gray)
            Text(text)
                .font(.caption)
                .foregroundColor(isActive ? .purple : .gray)
        }
    }
}
