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
                .stroke(Color.theme.darkGray, lineWidth: 4)
        )
        .background(Color.theme.backgroundColor)
        .cornerRadius(8, corners: [.allCorners])
        .shadow(color: .theme.darkGray, radius: 4)
    }

    @ViewBuilder
    private func leadingColumn() -> some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.callout)
                .foregroundColor(Color.theme.lightGray)
                .frame(minWidth: 16, alignment: .leading)

            Circle()
                .frame(width: 40, height: 40)

            Text(coin.symbol.uppercased())
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading, 8)
                .foregroundColor(.theme.secondaryColor)
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
                .foregroundColor(.theme.accentColor)

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
