//
//  AppDestinationViewer.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Model
import Navigation
import SwiftUI

class AppDestinationViewer: DestinationViewer<Destination> {
    @ViewBuilder
    override func view(for destination: Destination) -> any View {
        switch destination {
        case .root:
            RootView()

        case .dashboard:
            DashboardView()

        case .profile:
            ProfileView()

        case .coinDetail(let coin):
            CoinDetailView(coin: coin)
        }
    }
}
