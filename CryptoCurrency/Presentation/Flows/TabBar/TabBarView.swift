//
//  TabBarView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import ShortcutFoundation
import SwiftUI

struct TabBarView: View {
    @InjectObject private var vm: TabBarViewModel

    var body: some View {
        TabView(selection: $vm.selectedTab) {
            ForEach(vm.tabs) { tab in
                view(for: tab)
                    .tabItem {
                        Label(tab.title, image: tab.asset)
                    }
                    .tag(tab)
                    .frame(maxHeight: .infinity)
            }
        }
        .preferredColorScheme(.dark)
        .accentColor(.theme.accentColor)
    }

    @ViewBuilder
    private func view(for tab: TabBarViewModel.Tab) -> some View {
        switch tab {
        case .dashboard:
            DashboardView()

        case .profile:
            ProfileView()
            
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
