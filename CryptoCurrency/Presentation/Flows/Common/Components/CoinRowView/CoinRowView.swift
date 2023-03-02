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
            leadingColumn()

            Spacer()

            if isPresentingHoldingsColumn {
                centerColumn()
            }

            trailingColumn()
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.theme.backgroundColor, lineWidth: 1)
        )
        .background(Color.theme.darkGray)
        .cornerRadius(8, corners: [.allCorners])
    }

    @ViewBuilder
    private func leadingColumn() -> some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 40, height: 40)

            Text(coin.symbol.uppercased())
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading, 8)
                .foregroundColor(.theme.textColor)
        }
    }

    @ViewBuilder
    private func centerColumn() -> some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(.theme.lightGray)
    }

    @ViewBuilder
    private func trailingColumn() -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(.theme.textColor)

            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green : Color.theme.red
                )
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: CoinModel.mockCoin, isPresentingHoldingsColumn: true)
    }
}
