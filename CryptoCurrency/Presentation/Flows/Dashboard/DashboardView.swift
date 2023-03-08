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
                .sheet(isPresented: $vm.isPresentingPortfolioSheet) {
                    PortfolioView(vm: vm)
                }

            VStack(spacing: 0) {
                headerView()

                DashboardStatsView(showPortfolio: $vm.isPresentingPortfolio, statistics: vm.statistics)

                SearchBarView(searchText: $vm.searchText)
                    .padding(16)

                Group {
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.theme.backgroundColor)
                    } else if vm.isPresentingPortfolio {
                        coinsList(
                            for: vm.portfolioCoins,
                            showsHoldings: true,
                            showEmptyState: vm.shouldDisplayPortfolioEmptyState()
                        )
                        .transition(.move(edge: .trailing))

                    } else {
                        coinsList(
                            for: vm.coinsList,
                            showsHoldings: false,
                            showEmptyState: vm.shouldDisplayAllCoinsEmptyState()
                        )
                        .transition(.move(edge: .leading))
                    }
                }

                Spacer(minLength: 0)
            }
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 0) {
            CircleButtonView(iconName: vm.isPresentingPortfolio ? "plus" : "info")
                .animation(.none, value: vm.isPresentingPortfolio)
                .onTapGesture { vm.presentPortfolioSheet() }
                .background(
                    CircleButtonAnimationView(animate: $vm.isPresentingPortfolio)
                        .foregroundColor(.theme.secondaryColor)
                )

            Spacer()

            Text(vm.isPresentingPortfolio ? "Portfolio" : "Live Prices")
                .font(.textStyle.mediumText)
                .fontWeight(.bold)
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
        .background(Color.theme.mediumDarkBlue)
    }

    @ViewBuilder
    private func columnTitles() -> some View {
        HStack(spacing: 0) {
            Text("COIN")

            Spacer()

            if vm.isPresentingPortfolio {
                Text("HOLDINGS")
            }

            Text("PRICE")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .foregroundColor(.theme.lightGray)
        .font(.textStyle.smallestText)
    }

    @ViewBuilder
    private func coinsList(for list: [CoinModel], showsHoldings: Bool = false, showEmptyState: Bool) -> some View {
        VStack(spacing: 0) {
            if showEmptyState {
                VStack(spacing: 0) {
                    Text("No coins to display")
                        .foregroundColor(.theme.textColor)
                        .font(.textStyle.smallText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.backgroundColor)
            } else {
                VStack(spacing: 0) {
                    columnTitles()
                        .padding(.horizontal, 32)
                        .padding(.bottom, 8)

                    List {
                        ForEach(list) { coin in
                            CoinRowView(coin: coin, isPresentingHoldingsColumn: showsHoldings)
                                .modifier(ListRowBackgroundModifier(color: .theme.backgroundColor))
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
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
