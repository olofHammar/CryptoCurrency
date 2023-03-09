//
//  CoinDetailViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-09.
//

import Combine
import Domain
import Model
import ShortcutFoundation
import SwiftUI

final class CoinDetailViewModel: ObservableObject {
    @Inject private var fetchCoinDetailUseCase: IFetchCoinDetailUseCase

    @Published private(set) var coin: CoinModel
    @Published private(set) var coinDetailModel: CoinDetailModel?
    @Published private(set) var overviewStatistics: [StatisticsModel] = []
    @Published private(set) var additionalStatistics: [StatisticsModel] = []

    private var cancellables = Set<AnyCancellable>()

    init(
        coin: CoinModel
    ) {
        self.coin = coin

        startObservingCoinDetail()
    }

    private func startObservingCoinDetail() {
        $coin
            .map({ (coinModel) -> [StatisticsModel] in
                let price = coinModel.currentPrice.asCurrencyWith6Decimals()
                let pricePercentageChange = coinModel.priceChangePercentage24H
                let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)

                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "N/A")
                let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
                let marketCapStat = StatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)

                let rank = "\(coinModel.rank)"
                let rankStat = StatisticsModel(title: "Rank", value: rank)

                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "N/A")
                let volumeStat = StatisticsModel(title: "Volume", value: volume)

                let overviewArray: [StatisticsModel] = [
                    priceStat, marketCapStat, rankStat, volumeStat
                ]

                return overviewArray
            })
            .receive(on: RunLoop.main)
            .assign(to: &$overviewStatistics)

        fetchCoinDetailUseCase.execute(with: coin.id)
            .map({ (coinDetailModel) -> [StatisticsModel] in
//                let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
//                let highStat = StatisticsModel(title: "24h Hight", value: high)
//
//                let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
//                let lowStat = StatisticsModel(title: "24h Low", value: low)
//
//                let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
//                let pricePercetageChange2 = coinModel.priceChangePercentage24H
//                let priceChangeStat = StatisticsModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercetageChange2)
//
//                let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
//                let marketCapPercentageChange2 = coinModel.marketCapChangePercentage24H
//                let marketCapChangeStat = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange2)

                let blockTime = coinDetailModel.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
                let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)

                let hashing = coinDetailModel.hashingAlgorithm ?? "N/A"
                let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)

                let additionalArray: [StatisticsModel] = [
                    blockStat, hashingStat
                ]
                return additionalArray
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching details: \(error.localizedDescription)")
                }
            } receiveValue: { [unowned self] (detailModel) in
                self.additionalStatistics = detailModel
            }
            .store(in: &cancellables)
    }
}
