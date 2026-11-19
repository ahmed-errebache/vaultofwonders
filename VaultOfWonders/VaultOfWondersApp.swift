import SwiftUI

@main
struct VaultOfWondersApp: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var tokenVM = TokenViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(collectionVM)
                .environmentObject(tokenVM)
        }
    }
}
