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

                DashboardStatsView(showPortfolio: $vm.isPresentingPortfolio, statistics: vm.statistics)

                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.theme.backgroundColor)
                } else if vm.isPresentingPortfolio {
                    portfolioList()
                        .transition(.move(edge: .trailing))

                } else {
                    allCoinsList()
                        .transition(.move(edge: .leading))
                }

                Spacer(minLength: 0)
            }
            .sheet(isPresented: $vm.isPresentingPortfolioSheet) {
                PortfolioView(vm: vm)
            }
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                CircleButtonView(iconName: vm.isPresentingPortfolio ? "plus" : "magnifyingglass")
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

            if vm.isPresentingSearchBar {
                SearchBarView(searchText: $vm.searchText)
                    .padding([.horizontal, .bottom], 16)
                    .animation(.linear, value: vm.isPresentingSearchBar)
            }
        }
        .background(Color.theme.mediumDarkBlue)
    }

    @ViewBuilder
    private func columnTitles() -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                Text("COIN")

                Image(systemName: "chevron.down")
                    .opacity(vm.isSortedByRank() ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.isSortedByRank() ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.selectedSortOption = vm.selectedSortOption == .rank ? .rankReversed : .rank
                }
            }

            Spacer()

            if vm.isPresentingPortfolio {
                HStack(spacing: 4) {
                    Text("HOLDINGS")

                    Image(systemName: "chevron.down")
                        .opacity(vm.isSortedByHoldings() ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.isSortedByHoldings() ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.selectedSortOption = vm.selectedSortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }

            HStack(spacing: 4) {
                Text("PRICE")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)

                Image(systemName: "chevron.down")
                    .opacity(vm.isSortedByPrice() ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.isSortedByPrice() ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.selectedSortOption = vm.selectedSortOption == .price ? .priceReversed : .price
                }
            }
        }
        .foregroundColor(.theme.lightGray)
        .font(.textStyle.smallestText)
    }

    @ViewBuilder
    private func allCoinsList() -> some View {
        VStack(spacing: 0) {
            if vm.shouldDisplayAllCoinsEmptyState() {
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
                        ForEach(vm.coinsList) { coin in
                            CoinRowView(coin: coin, isPresentingHoldingsColumn: false)
                                .modifier(ListRowBackgroundModifier(color: .theme.backgroundColor))
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .onTapGesture {
                                    vm.navigateToCoinDetail(with: coin)
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    .refreshable {
                        vm.reloadData()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func portfolioList() -> some View {
        VStack(spacing: 0) {
            if vm.shouldDisplayPortfolioEmptyState() {
                VStack(spacing: 0) {
                    Text("Your portfolio is empty")
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
                        ForEach(vm.portfolioCoins) { coin in
                            CoinRowView(coin: coin, holdings: coin.currentHoldings, isPresentingHoldingsColumn: true)
                                .modifier(ListRowBackgroundModifier(color: .theme.backgroundColor))
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    .refreshable {
                        vm.reloadData()
                    }
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
