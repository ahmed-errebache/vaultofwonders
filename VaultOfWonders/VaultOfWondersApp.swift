import SwiftUI

@main
struct VaultOfWondersApp: App {
    @StateObject private var collectionVM = CollectionViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(collectionVM)
        }
    }
}
