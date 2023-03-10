//
//  CoinDetailView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Model
import SwiftUI

struct CoinDetailView: View {
    @StateObject private var vm: CoinDetailViewModel

    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]

    init(
        coin: CoinModel
    ) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("")
                    .frame(height: 150)

                statisticsGridView(title: "Overview", stats: vm.overviewStatistics)

                statisticsGridView(title: "Additional Details", stats: vm.additionalStatistics)

            }
            .padding(.horizontal, 16)
            .foregroundColor(.theme.textColor)
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.backgroundColor)
        .navigationTitle(vm.coin.name)
    }

    @ViewBuilder
    private func statisticsGridView(title: String, stats: [StatisticsModel]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.textStyle.mediumText)
                .bold()

            LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                ForEach(stats) { stat in
                    StatisticsView(stat: stat)
                }
            }
        }

    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: .mockCoin)
    }
}
