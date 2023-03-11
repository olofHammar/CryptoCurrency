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
    let holdings: Double?
    let isPresentingHoldingsColumn: Bool


    init(
        coin: CoinModel,
        holdings: Double? = nil,
        isPresentingHoldingsColumn: Bool = false
    ) {
        self.coin = coin
        self.holdings = holdings
        self.isPresentingHoldingsColumn = isPresentingHoldingsColumn
    }

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
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .modifier(GradientCardModifier(cornerRadius: 4))
    }

    @ViewBuilder
    private func leadingColumn() -> some View {
        HStack(spacing: 0) {
            CoinImageView(coin: coin)
                .frame(width: 40, height: 40)

            Text(coin.symbol.uppercased())
                .font(.textStyle.mediumText)
                .fontWeight(.heavy)
                .padding(.leading, 8)
                .foregroundColor(.theme.textColor)
        }
    }

    @ViewBuilder
    private func centerColumn() -> some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
//            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(.theme.lightGray)
        .font(.textStyle.smallText)
    }

    @ViewBuilder
    private func trailingColumn() -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .foregroundColor(.theme.textColor)

//            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
//                .foregroundColor(
//                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
//                    Color.theme.green : Color.theme.red
//                )
        }
        .font(.textStyle.smallText)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: CoinModel.mockCoin, holdings: nil, isPresentingHoldingsColumn: false)
    }
}
