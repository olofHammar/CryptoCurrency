//
//  PortfolioView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Model
import SwiftUI

struct PortfolioView: View {

    @ObservedObject var vm: DashboardViewModel
    @Namespace private var animation

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SearchBarView(searchText: $vm.searchText)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)

                    coinIconsList()

                    if let coin = vm.selectedCoin {
                        portfolioInputSection(for: coin)
                            .padding(.top, 8)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .navigationBarTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: vm.dismissPortfolioSheet) {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    savePortfolioButton()
                }
            }
            .background(Color.theme.backgroundColor)
            .foregroundColor(.theme.lightGray)
            .onChange(of: vm.searchText) { value in
                if value.isEmpty {
                    vm.resetSelectedCoin()
                }
            }
        }
    }

    @ViewBuilder
    private func coinIconsList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.coinsList) { coin in
                    VStack(spacing: 8) {
                        CoinIconView(coin: coin)
                            .frame(width: 50)

                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(vm.isSelectedCoin(coin) ? .theme.textColor : .theme.backgroundColor)
                    }
                    .animation(.easeInOut, value: vm.isSelectedCoin(coin))
                    .padding(.horizontal, 16)
                    .scaleEffect(vm.isSelectedCoin(coin) ? 1.1 : 1)
                    .onTapGesture { vm.setSelectedCoin(with: coin) }
                }
            }
        }
        .frame(minHeight: 120)
    }

    @ViewBuilder
    private func portfolioInputSection(for coin: CoinModel) -> some View {
        VStack(alignment: .leading, spacing: 24) {

            portfolioInputRow(
                title: "Current price of \(coin.symbol.uppercased())",
                value: coin.currentPrice.asCurrencyWith6Decimals()
            )

            HStack {
                Text("Amount holding:")


                Spacer()

                TextField("Ex: 1.4", text: $vm.quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            portfolioInputRow(
                title: "Current value:",
                value: vm.quantityValue().asCurrencyWith2Decimals()
            )

        }
        .animation(.none, value: vm.selectedCoin)
        .font(.textStyle.mediumText)
        .foregroundColor(.theme.textColor)
    }

    @ViewBuilder
    private func portfolioInputRow(title: String, value: String) -> some View {
        HStack(spacing: 0) {
            Text(title)

            Spacer()

            Text(value)
        }
    }

    @ViewBuilder
    private func savePortfolioButton() -> some View {
        Button(action: vm.savePortfolioData) {
            Text("Save")
                .font(.textStyle.mediumText)
                .foregroundColor(.theme.textColor)
        }
        .opacity(vm.shouldPresentSavePortfolioButton ? 1 : 0)
        .allowsHitTesting(vm.shouldPresentSavePortfolioButton)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(vm: DashboardViewModel())
    }
}
