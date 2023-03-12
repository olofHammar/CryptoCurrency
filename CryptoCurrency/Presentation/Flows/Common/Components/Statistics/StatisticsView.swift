//
//  StatisticsView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Model
import SwiftUI

struct StatisticsView: View {

    private let stat: StatisticsModel
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat

    init(
        stat: StatisticsModel,
        verticalPadding: CGFloat = 16,
        horizontalPadding: CGFloat = 16
    ) {
        self.stat = stat
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title.uppercased())
                .font(.textStyle.smallestTextBold)
                .bold()
                .foregroundColor(.theme.textColorSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(stat.value)
                .font(.textStyle.mediumText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.textStyle.smallestText)
                    .rotationEffect(Angle(degrees: (stat.percetageChange ?? 0) >= 0 ? 0 : 180))

                Text(stat.percetageChange?.asPercentageString() ?? "")
                    .font(.textStyle.smallestText)
                    .bold()
            }
            .foregroundColor((stat.percetageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percetageChange == nil ? 0 : 1)
        }
        .foregroundColor(.theme.textColor)
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            StatisticsView(stat: .mockModel1)

            StatisticsView(stat: .mockModel2)

            StatisticsView(stat: .mockModel3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.theme.backgroundColor)
    }
}
