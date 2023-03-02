//
//  DashboardView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Navigation
import Model
import ShortcutFoundation
import SwiftUI

struct DashboardView: View {
    @InjectObject private var vm: DashboardViewModel

    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView()

                List {
                    ForEach(vm.coinsList) { coin in
                        CoinRowView(coin: coin, isPresentingHoldingsColumn: false)
                            .modifier(ListRowBackgroundModifier(color: .theme.backgroundColor))
                    }
                }
                .listStyle(PlainListStyle())

                Spacer(minLength: 0)
            }
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 0) {
            CircleButtonView(iconName: vm.isPresentingPortfolio ? "plus" : "info")
                .animation(.none, value: vm.isPresentingPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $vm.isPresentingPortfolio)
                        .foregroundColor(.theme.lightGray)
                )

            Spacer()

            Text(vm.isPresentingPortfolio ? "Portfolio" : "Live Prices")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.theme.textColor)
                .animation(.none)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: vm.isPresentingPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        vm.togglePortfolioState()
                    }
                }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
