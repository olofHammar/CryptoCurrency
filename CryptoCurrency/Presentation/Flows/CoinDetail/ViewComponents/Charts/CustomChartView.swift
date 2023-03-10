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
    private let maxY: Double
    private let minY: Double
    private let lineColor: LinearGradient
    private let shadowColor: Color
    private let endingDate: Date
    private let startingDate: Date

    init(
        coin: CoinModel
    ) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0

        let priceChange = (data.last ?? 0) - (data.first ?? 0)

        self.lineColor = priceChange > 0 ? .green : .red
        self.shadowColor = priceChange > 0 ? .theme.darkGreen : .theme.darkRed
        self.endingDate = Date.init(coinGeckoString: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                chartView()
                    .frame(height: 150)
                    .background(chartBackground())
                    .overlay(chartYAxis(), alignment: .leading)
            }

            shortDateLabels()
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .modifier(GradientCardModifier())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1.5)) {
                    percetage = 1
                }
            }
        }
    }

    @ViewBuilder
    private func chartView() -> some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geo.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }

                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percetage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            .shadow(color: shadowColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: shadowColor.opacity(0.3), radius: 10, x: 0, y: 30)
            .shadow(color: shadowColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }

    @ViewBuilder
    private func chartBackground() -> some View {
        verticalGridItems(numberOfItems: 2)
            .overlay(
                horizontalGridItems(numberOfItems: 7)
            )
    }

    @ViewBuilder
    private func verticalGridItems(numberOfItems: Int) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<numberOfItems, id: \.self) { _ in
                VStack(spacing: 0) {
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
                .overlay(Color.theme.textColor)        }
    }

    @ViewBuilder
    private func chartYAxis() -> some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
                .offset(y: -16)

            Spacer()

            Text(((maxY + minY) / 2).formattedWithAbbreviations())
                .offset(y: -10)

            Spacer()

            Text(minY.formattedWithAbbreviations())
        }
        .font(.textStyle.smallestText)
        .bold()
        .foregroundColor(.theme.textColor)
    }

    @ViewBuilder
    private func shortDateLabels() -> some View {
        HStack(spacing: 0) {
            Text(startingDate.asShortDateString().uppercased())

            Spacer()

            Text(endingDate.asShortDateString().uppercased())
        }
        .font(.textStyle.smallestText)
        .bold()
        .foregroundColor(.theme.textColor)
    }

    @ViewBuilder
    private func customDivider(
        with strokeThickness: CGFloat = 2,
        color: Color = Color.theme.lightGray
    ) -> some View {
        Rectangle()
            .frame(height: strokeThickness)
            .foregroundColor(color)
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

fileprivate extension LinearGradient {
    static var green = LinearGradient(colors: [
        Color.theme.darkGreen,
        Color.theme.intenseGreen,
        Color.theme.green
    ], startPoint: .bottom, endPoint: .top)

    static var red = LinearGradient(colors: [
        Color.theme.darkRed,
        Color.theme.intenseRed,
        Color.theme.red
    ], startPoint: .bottom, endPoint: .top)
}
