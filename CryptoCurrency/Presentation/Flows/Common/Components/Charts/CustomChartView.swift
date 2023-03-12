//
//  CustomChartView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-10.
//

import Model
import SwiftUI

struct CustomChartView: View {

    @State private var percetage: CGFloat = 0

    private let data: [Double]
    private var yAxisData: [Double]

    private let lineColor: Color
    private let shadowColor: Color
    private let endingDate: Date
    private let startingDate: Date

    init(
        coin: CoinModel
    ) {
        self.data = coin.sparklineIn7D?.price ?? []

        let minY = data.min() ?? 0
        let maxY = data.max() ?? 0
        let middleY = (maxY + minY) / 2
        self.yAxisData = [maxY, middleY, minY]

        let priceChange = (data.last ?? 0) - (data.first ?? 0)

        self.lineColor = priceChange > 0 ? .theme.green : .theme.red
        self.shadowColor = priceChange > 0 ? .theme.intenseGreen : .theme.intenseRed
        self.endingDate = Date.init(coinGeckoString: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                chartYAxis()
                
                ChartLineView(
                    data: data,
                    lineColor: lineColor,
                    shadowColor: shadowColor,
                    isAnimating: true
                )
                    .background(chartBackground())
            }
            .frame(height: .defaultChartHeight)

            shortDateLabels()
        }
        .frame(maxWidth: .infinity)
        .padding(.x2)
        .modifier(CardModifier(cornerRadius: .x1))
    }

    @ViewBuilder
    private func chartBackground() -> some View {
        verticalGridItems(numberOfItems: 2)
    }

    @ViewBuilder
    private func verticalGridItems(numberOfItems: Int) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<numberOfItems, id: \.self) { _ in
                VStack(spacing: 0) {
                    Divider()
                        .overlay(Color.theme.textColorSecondary.opacity(0.1))
                        .frame(minHeight: 16, alignment: .bottom)
                    Spacer()
                }
            }
            Divider()
                .overlay(Color.theme.textColorSecondary.opacity(0.1))
                .frame(minHeight: 16, alignment: .bottom)
        }
    }

    @ViewBuilder
    private func horizontalGridItems(numberOfItems: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfItems, id: \.self) { _ in
                HStack(spacing: 0) {
                    Divider()
                        .overlay(Color.theme.textColor)
                    Spacer()
                }
            }
            Divider()
                .overlay(Color.theme.textColor)
        }
    }

    @ViewBuilder
    private func chartYAxis() -> some View {
        VStack(spacing: 0) {
            ForEach(yAxisData.indexedArray(), id: \.self) { index in
                Text(index.element.formattedWithAbbreviations())

                if !index.position.isLast {
                    Spacer()
                }
            }
        }
        .font(.textStyle.smallestTextBold)
        .bold()
        .foregroundColor(.theme.lightGray)
    }

    @ViewBuilder
    private func shortDateLabels() -> some View {
        HStack(spacing: 0) {
            Text(startingDate.asShortDateString().uppercased())

            Spacer()

            Text(endingDate.asShortDateString().uppercased())
        }
        .font(.textStyle.smallestTextBold)
        .bold()
        .foregroundColor(.theme.textColorSecondary)
    }
}

struct CustomChartView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomChartView(coin: .mockCoin)
            Spacer()
        }
        .background(Color.theme.backgroundColor)
    }
}
