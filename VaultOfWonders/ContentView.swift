//
//  ContentView.swift
//  VaultOfWonders
//
//  Created by Ahmed Errebache on 29/05/2026.
//

import SwiftUI
struct ContentView: View {
    @State var selectedTab: BottomBarSelectedTab = .home
    
    var body: some View {
        VStack {
            if selectedTab == .home {
                Text("Vault Of Wonders")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            } else if selectedTab == .chance {
                Text("Chance")
            } else if selectedTab == .collection {
                Text("Collection")
            }
            Spacer()
            BottomBar(selectedTab: $selectedTab)
        }
    }
}
 
