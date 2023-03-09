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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SearchBarView(searchText: $vm.searchText)
                        .padding(.top, 8)

                    coinIconsList()

                    if let coin = vm.selectedCoin {
                        portfolioInputSection(for: coin)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Select coin".uppercased())
                .font(.textStyle.smallestText)
                .bold()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(vm.coinsList) { coin in
                        VStack(spacing: 8) {
                            CoinIconView(coin: coin)
                                .frame(width: 50)

                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(vm.isSelectedCoin(coin) ? .theme.textColor : .theme.backgroundColor)
                        }
                        .onTapGesture { vm.setSelectedCoin(with: coin) }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func portfolioInputSection(for coin: CoinModel) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.theme.blueShadow)

            HStack {
                Text("Current price of \(coin.symbol.uppercased()):")

                Spacer()

                Text(coin.currentPrice.asCurrencyWith6Decimals())
            }

            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.theme.blueShadow)

            HStack {
                Text("Amount holding:")


                Spacer()

                TextField("Ex: 1.4", text: $vm.quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.theme.blueShadow)

            HStack {
                Text("Current value:")

                Spacer()

                Text(vm.quantityValue().asCurrencyWith2Decimals())
            }

        }
        .animation(.none, value: vm.selectedCoin)
        .font(.textStyle.mediumText)
        .foregroundColor(.theme.textColor)
    }

    @ViewBuilder
    private func savePortfolioButton() -> some View {
        Button(action: { }) {
            Text("Save")
                .font(.textStyle.mediumText)
                .foregroundColor(.theme.textColor)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(vm: DashboardViewModel())
    }
}
