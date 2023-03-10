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
    @Inject private var portfolioDataService: PortfolioDataService
    @Inject private var fetchCoinDetailUseCase: IFetchCoinDetailUseCase

    @Published private(set) var coin: CoinModel
    @Published private(set) var overviewStatistics: [StatisticsModel] = []
    @Published private(set) var additionalStatistics: [StatisticsModel] = []

    @Published var isPresentingBuyCoinSheet = false
    @Published var shouldPresentSaveButton = false
    @Published var quantityText: String = ""

    private var cancellables = Set<AnyCancellable>()

    init(
        coin: CoinModel
    ) {
        self.coin = coin

        startObservingCoinDetail()
        startObservingViewStateChanges()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    func saveCoinToPortfolio() {
        guard let amount = Double(quantityText) else {
            return
        }
        updatePortfolio(coin: coin, amount: amount)
    }

    func quantityValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * coin.currentPrice
        }
        return 0
    }

    func presentBuySheet() {
        isPresentingBuyCoinSheet = true
    }

    func dismissBuySheet() {
        isPresentingBuyCoinSheet = false
    }

    private func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    private func startObservingCoinDetail() {
        $coin
            .flatMap { [fetchCoinDetailUseCase] coin in
                fetchCoinDetailUseCase.execute(with: coin.id)
                    .map { ($0, coin) }
                    .catch { error -> AnyPublisher<(CoinDetailModel, CoinModel), RequestError> in
                        return Empty<(CoinDetailModel, CoinModel), RequestError>().eraseToAnyPublisher()
                    }
            }
            .map(mapCoinToStatistics)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching coin detail: \(error)")
                }
            } receiveValue: { [weak self] (returnedStatistics) in
                guard let self = self else {
                    return
                }
                self.overviewStatistics = returnedStatistics.overview
                self.additionalStatistics = returnedStatistics.additional
            }
            .store(in: &cancellables)

    }

    private func startObservingViewStateChanges() {
        $quantityText
            .map { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .assign(to: &$shouldPresentSaveButton)
    }

    private func mapCoinToStatistics(coinDetailModel: CoinDetailModel, coinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)

        return (overviewArray, additionalArray)
    }

    private func createOverviewArray(coinModel: CoinModel) -> [StatisticsModel] {
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

        let overviewArray: [StatisticsModel] = [priceStat, marketCapStat, rankStat, volumeStat]

        return overviewArray
    }

    private func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel) -> [StatisticsModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStat = StatisticsModel(title: "24h Hight", value: high)

        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStat = StatisticsModel(title: "24h Low", value: low)

        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let pricePercetageChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticsModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercetageChange)

        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange)

        let blockTime = coinDetailModel.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetailModel.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)

        let additionalArray: [StatisticsModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]

        return additionalArray
    }
}
