import SwiftUI

struct RootView: View {
    @EnvironmentObject var collectionVM: CollectionViewModel
    @StateObject private var homeVM = HomeViewModel()
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack {
            VStack {
                if selectedTab == .home {
                    HomeView(vm: homeVM)
                } else if selectedTab == .chance {
                    ChanceView()
                } else if selectedTab == .machine {
                    MachineView()
                } else if selectedTab == .collection {
                    CollectionView()
                }
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }

            if homeVM.showPopup {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .transition(.opacity)

                PackOpeningView(vm: homeVM) {
                    homeVM.collectCards(into: collectionVM)
                }
            }
        }
    }
}
