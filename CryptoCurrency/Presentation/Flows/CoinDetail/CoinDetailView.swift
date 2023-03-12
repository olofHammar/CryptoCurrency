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
                VStack(alignment: .leading, spacing: 24) {
                    Text("LATEST WEEKS")
                        .font(.textStyle.mediumText)
                        .bold()
                        .foregroundColor(.theme.lightGray)

                    CustomChartView(coin: vm.coin)
                }
                .padding(.vertical, 32)


                statisticsGridView(title: "Overview", stats: vm.overviewStatistics)
                    .padding(.bottom, 32)

                statisticsGridView(title: "Additional Details", stats: vm.additionalStatistics)
                    .padding(.bottom, 32)

            }
            .padding(.horizontal, 16)
            .foregroundColor(.theme.textColor)
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.backgroundColor)
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: vm.presentBuySheet) {
                    Image(systemName: "plus")
                        .font(.textStyle.smallText)
                        .foregroundColor(.theme.textColor)
                }
            }
        }
        .sheet(isPresented: $vm.isPresentingBuyCoinSheet) {
            BuyCoinView(vm: vm)
        }
    }

    @ViewBuilder
    private func titleRow() -> some View {
        HStack(spacing: 8) {
            CoinImageView(coin: vm.coin)
                .frame(width: 30)

            Text(vm.coin.name.uppercased())
                .font(.textStyle.title)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    @ViewBuilder
    private func statisticsGridView(title: String, stats: [StatisticsModel]) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(title.uppercased())
                .font(.textStyle.mediumText)
                .bold()
                .foregroundColor(.theme.lightGray)

            LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                ForEach(stats) { stat in
                    StatisticsView(stat: stat, horizontalPadding: 0)
                        .frame(width: UIScreen.main.bounds.width / 2, alignment: .leading)
                }
            }
            .padding(.horizontal, 16)
            .modifier(CardModifier(cornerRadius: 8))
        }
    }

    @ViewBuilder
    private func divider() -> some View {
        Rectangle()
            .padding(.trailing, -16)
            .frame(height: 2)
            .foregroundColor(.theme.darkBlue)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CoinDetailView(coin: .mockCoin)
        }
    }
}
