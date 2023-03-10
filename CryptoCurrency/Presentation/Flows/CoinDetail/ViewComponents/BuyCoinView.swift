//
//  BuyCoinView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-10.
//

import Model
import SwiftUI

struct BuyCoinView: View {

    @ObservedObject var vm: CoinDetailViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    CoinImageView(coin: vm.coin)
                        .padding(.vertical, 24)
                        .frame(width: 120)
                        .frame(maxWidth: .infinity)

                    portfolioInputSection(for: vm.coin)

                }
                .padding(.horizontal, 24)
            }
            .navigationBarTitle("Buy \(vm.coin.name)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: vm.dismissBuySheet) {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    savePortfolioButton()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.theme.backgroundColor)
            .foregroundColor(.theme.lightGray)
        }
    }


    @ViewBuilder
    private func portfolioInputSection(for coin: CoinModel) -> some View {
        VStack(alignment: .leading, spacing: 24) {

            portfolioInputRow(
                title: "Current price of \(coin.symbol.uppercased())",
                value: coin.currentPrice.asCurrencyWith6Decimals()
            )

            HStack {
                Text("Amount to buy:")


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
        Button(action: vm.saveCoinToPortfolio) {
            Text("Save")
                .font(.textStyle.mediumText)
                .foregroundColor(.theme.textColor)
        }
        .opacity(vm.shouldPresentSaveButton ? 1 : 0)
        .allowsHitTesting(vm.shouldPresentSaveButton)
    }
}

struct BuyCoinView_Previews: PreviewProvider {
    static var previews: some View {
        BuyCoinView(vm: CoinDetailViewModel(coin: .mockCoin))
    }
}
