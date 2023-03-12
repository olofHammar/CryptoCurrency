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
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .leading)

            Spacer()

            centerColumn()

            trailingColumn()
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .modifier(CardModifier(cornerRadius: 4))
    }

    @ViewBuilder
    private func leadingColumn() -> some View {
        HStack(spacing: 0) {
            CoinImageView(coin: coin)
                .frame(width: 25)

            VStack(alignment: .leading, spacing: 0) {
                Text(coin.symbol.uppercased())
                    .font(.textStyle.smallTextBold)
                    .foregroundColor(.theme.textColor)

                Text(coin.name)
                    .font(.textStyle.smallText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(.leading, 8)
            .foregroundColor(.theme.textColorSecondary)
        }
    }

    @ViewBuilder
    private func centerColumn() -> some View {
        if isPresentingHoldingsColumn {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundColor(.theme.lightGray)
            .font(.textStyle.smallText)
        } else {
            ChartLineView(data: coin.sparklineIn7D?.price ?? [], shadowColor: .clear)
                .frame(maxHeight: 100)
                .frame(minWidth: UIScreen.main.bounds.width / 3.5)
                .overlay(gradientOverlay())
        }
    }

    @ViewBuilder
    private func trailingColumn() -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .font(.textStyle.smallTextBold)
                .foregroundColor(.theme.textColor)

            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green : Color.theme.red
                )
        }
        .font(.textStyle.smallText)
    }

    @ViewBuilder
    private func gradientOverlay() -> some View {
        LinearGradient(colors: [
            .theme.secondaryBackground,
            .clear,
            .clear,
            .clear,
            .theme.secondaryBackground
        ], startPoint: .leading, endPoint: .trailing)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: CoinModel.mockCoin, holdings: nil, isPresentingHoldingsColumn: false)

            CoinRowView(coin: CoinModel.mockCoin2, holdings: nil, isPresentingHoldingsColumn: false)
        }
    }
}
