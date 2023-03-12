//
//  ChartViewiOS.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-10.
//

import Charts
import Model
import SwiftUI

struct ChartViewiOS: View {

    let data: [Double]
    let maxY: CGFloat
    let minY: CGFloat

    private let lineColor: Color

    init(
        coin: CoinModel
    ) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = CGFloat(data.max() ?? 0)
        self.minY = CGFloat(data.min() ?? 0)

        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    }

    var body: some View {
        animatedChart()
    }

    @ViewBuilder
    private func animatedChart() -> some View {
        Chart {
            ForEach(graphData) { item in
                LineMark(
                    x: .value("Week Day", item.date, unit: .weekday),
                    y: .value("Price", item.priceValue)
                )
                .foregroundStyle(lineColor)
                .lineStyle(.init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.cardinal)
                .symbol(Circle())
            }
        }
        .modifier(CardModifier(cornerRadius: 0))
        .chartPlotStyle { plotContent in
          plotContent
                .background(Color.theme.shadow.opacity(0.8))
                .border(Color.theme.backgroundColor, width: 1)
        }
        .preferredColorScheme(.dark)
        .chartXAxis {
          AxisMarks(values: .automatic) { value in
              AxisValueLabel()
                  .foregroundStyle(Color.theme.textColor)
                  .font(.textStyle.graphText)
          }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
            AxisValueLabel() { // construct Text here
              if let intValue = value.as(Double.self) {
                  Text(intValue.formattedWithAbbreviations())
                      .font(.textStyle.graphText)
                      .foregroundColor(.theme.textColor)
              }
            }
          }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(.blue.opacity(1))
        }
    }

    private var graphData: [GraphData] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let dayOfWeek = calendar.component(.weekday, from: startOfWeek)
        let numDays = 7
        let numValuesPerDay = Int(ceil(Double(data.count) / Double(numDays)))
        var graphData: [GraphData] = []
        for i in 0..<numDays {
            let startIndex = i * numValuesPerDay
            let endIndex = min(startIndex + numValuesPerDay, data.count)
            let values = Array(data[startIndex..<endIndex])
            let pointValue = values.reduce(0, +) / Double(values.count)
            let date = calendar.date(byAdding: .day, value: i - dayOfWeek, to: startOfWeek)!
            let graphDataItem = GraphData(date: date, pointValue: pointValue)
            graphData.append(graphDataItem)
        }
        return graphData
    }
}

struct ChartViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ChartViewiOS(coin: .mockCoin)
    }
}

struct GraphData: Identifiable {
    let id = UUID().uuidString
    let date: Date
    let priceValue: Double

    init(
        date: Date,
        pointValue: Double
    ) {
        self.date = date
        self.priceValue = pointValue
    }
}
