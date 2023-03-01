//
//  CoinRowView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Model
import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let isPresentingHoldingsColumn: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.lightGray)
                .frame(minWidth: 32)

            Circle()
                .frame(width: 30, height: 30)

            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 8)
                .foregroundColor(.theme.secondaryColor)

            Spacer()

            if isPresentingHoldingsColumn {
                VStack(alignment: .trailing) {
                    Text(coin.currentHoldingsValue.asCurrencyWithDecimals())
                    Text((coin.currentHoldings ?? 0).asNumberString())
                }
                .foregroundColor(.theme.lightGray)
            }

            VStack(alignment: .trailing, spacing: 0) {
                Text(coin.currentPrice.asCurrencyWithDecimals())
                    .bold()
                    .foregroundColor(.theme.accentColor)

                Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.theme.green : Color.theme.red
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 3)
        }
        .padding(16)
        .background(Color.theme.backgroundColor)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: CoinModel.mockCoin, isPresentingHoldingsColumn: true)
    }
}
