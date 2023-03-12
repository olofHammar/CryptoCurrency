//
//  ChartLineView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-12.
//

import SwiftUI

struct ChartLineView: View {
    @State private var percentage: CGFloat = 0

    let data: [Double]
    let minYValue: Double
    let maxYValue: Double
    let lineColor: Color
    let shadowColor: Color
    let isAnimating: Bool

    init(
        data: [Double],
        lineColor: Color = .theme.accentColor,
        shadowColor: Color = .theme.shadow,
        isAnimating: Bool = false
    ) {
        self.data = data
        self.minYValue = data.min() ?? 0
        self.maxYValue = data.max() ?? 0
        self.lineColor = lineColor
        self.shadowColor = shadowColor
        self.isAnimating = isAnimating
    }

    var body: some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxYValue - minYValue
                    let yPosition = (1 - CGFloat((data[index] - minYValue) / yAxis)) * geo.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }

                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: isAnimating ? percentage : maxYValue)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            .shadow(color: shadowColor.opacity(0.5), radius: 10, x: 0, y: 10)
            .shadow(color: shadowColor.opacity(0.3), radius: 10, x: 0, y: 20)
            .shadow(color: shadowColor.opacity(0.1), radius: 10, x: 0, y: 30)
            .clipped()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.linear(duration: 1.5)) {
                        percentage = 1
                    }
                }
            }
        }
    }
}

struct ChartLineView_Previews: PreviewProvider {
    static var previews: some View {
        ChartLineView(data: [0, 1, 2, 3, 4, 5])
    }
}
