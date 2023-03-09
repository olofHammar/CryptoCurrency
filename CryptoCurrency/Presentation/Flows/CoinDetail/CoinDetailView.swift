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

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 24

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

                Text("Overview")
                    .font(.textStyle.largeText)
                    .bold()

                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: []
                ) {
                    ForEach(vm.overviewStatistics) { stat in
                        StatisticsView(stat: stat)
                    }
                }
                Divider()

                Text("Additional Details")
                    .font(.textStyle.largeText)
                    .bold()

                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: []
                ) {
                    ForEach(vm.additionalStatistics) { stat in
                        StatisticsView(stat: stat)
                    }
                }
            }
            .padding(.horizontal, 16)
            .foregroundColor(.theme.textColor)
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.backgroundColor)
        .navigationTitle(vm.coin.name)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: .mockCoin)
    }
}
