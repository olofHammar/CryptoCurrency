//
//  TabBarViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Combine
import SwiftUI

final class TabBarViewModel: ObservableObject {
    @Published var selectedTab = Tab.dashboard

    var tabs: [Tab] = [.dashboard, .profile]

    init() { }
}

extension TabBarViewModel {
    enum Tab: Int {
        case dashboard = 0
        case profile
    }
}

extension TabBarViewModel.Tab: Identifiable {
    var id: Int { rawValue }

    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard"

        case .profile:
            return "Profile"
        }
    }

    var asset: String {
        switch self {
        case .dashboard:
            return "Images/overview"

        case .profile:
            return "Images/profile"
        }
    }
}
