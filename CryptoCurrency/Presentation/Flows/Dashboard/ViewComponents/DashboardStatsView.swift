//
//  DashboardStatsView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Model
import SwiftUI

struct DashboardStatsView: View {

    @Binding var showPortfolio: Bool

    let statistics: [StatisticsModel]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(statistics) { stat in
                StatisticsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct DashboardStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardStatsView(showPortfolio: .constant(false), statistics: [
            .mockModel1, .mockModel2, .mockModel3, .mockModel4
        ])
    }
}
