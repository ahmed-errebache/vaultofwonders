//
//  VaultOfWondersApp.swift
//  VaultOfWonders
//
//  Created by Ahmed Errebache on 29/05/2026.
//

import SwiftUI

@main
struct VaultOfWondersApp: App {
    @StateObject var store = CollectionStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
