//
//  DashboardViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Combine
import Domain
import Foundation
import Model
import ShortcutFoundation
import SwiftUI

final class DashboardViewModel: ObservableObject {
    @Inject var portfolioDataService: PortfolioDataService
    @Inject private var fetchAllSupportedCoinsUseCase: IFetchAllSupportedCoinsUseCase
    @Inject private var fetchGlobalMarketDataUseCase: IFetchGlobalMarketDataUseCase

    @Published private(set) var statistics: [StatisticsModel] = []
    @Published private(set) var allAvailableCoins: [CoinModel] = []
    @Published private(set) var coinsList: [CoinModel] = []
    @Published private(set) var portfolioCoins: [CoinModel] = []
    @Published private(set) var selectedCoin: CoinModel?

    @Published private(set) var isLoading = false
    @Published var isPresentingPortfolio = false
    @Published var isPresentingPortfolioSheet = false
    @Published var shouldPresentSavePortfolioButton = false

    @Published var searchText = ""
    @Published var quantityText = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        isLoading = true
        startObservingCoins()
        startObservingMarketData()
        startObservingViewStates()
    }

    func togglePortfolioState() {
        isPresentingPortfolio.toggle()
    }

    func presentPortfolioSheet() {
        guard isPresentingPortfolio else {
            return
        }

        isPresentingPortfolioSheet = true
    }

    func setSelectedCoin(with coin: CoinModel) {
        withAnimation(.easeInOut) {
            self.selectedCoin = coin

            if let portfolioCoin = portfolioCoins.first(where: { $0.id == coin.id }), let amount = portfolioCoin.currentHoldings {
                quantityText = "\(amount)"
            } else {
                quantityText = ""
            }
        }
    }

    func resetSelectedCoin() {
        selectedCoin = nil
        quantityText = ""
    }

    func isSelectedCoin(_ coin: CoinModel) -> Bool {
        self.selectedCoin == coin
    }

    func dismissPortfolioSheet() {
        resetSelectedCoin()
        isPresentingPortfolioSheet = false
    }

    func shouldDisplayPortfolioEmptyState() -> Bool {
        portfolioCoins.isEmpty
    }

    func shouldDisplayAllCoinsEmptyState() -> Bool {
        coinsList.isEmpty
    }

    func quantityValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func savePortfolioData() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else {
            return
        }
        updatePortfolio(coin: coin, amount: amount)

        withAnimation(.easeIn) {
            resetSelectedCoin()
        }
    }

    private func startObservingCoins() {
        fetchAllSupportedCoinsUseCase.execute()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { coins in
                self.allAvailableCoins = coins
            }
            .store(in: &cancellables)

        $searchText
            .combineLatest($allAvailableCoins)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map(filteredCoinsList)
            .receive(on: RunLoop.main)
            .assign(to: &$coinsList)

        $coinsList
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntites) -> [CoinModel] in
                coinModels.compactMap { (coin) -> CoinModel? in
                    guard let entity = portfolioEntites.first(where: { $0.coinID == coin.id }) else {
                        return nil
                    }

                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .receive(on: RunLoop.main)
            .assign(to: &$portfolioCoins)
    }

    private func startObservingMarketData() {
        fetchGlobalMarketDataUseCase.execute()
            .compactMap(mapGlobalMarketData)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching market data: \(error)")
                }
            } receiveValue: { globalMarketData in
                self.statistics = globalMarketData
            }
            .store(in: &cancellables)

    }

    private func startObservingViewStates() {
        $selectedCoin
            .combineLatest($quantityText)
            .compactMap(validatePortfolioSaveState)
            .receive(on: RunLoop.main)
            .assign(to: &$shouldPresentSavePortfolioButton)
    }

    private func filteredCoinsList(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }

        let lowecaseText = text.lowercased()

        return coins.filter { (coin) -> Bool in
            coin.name.lowercased().contains(lowecaseText) ||
            coin.symbol.lowercased().contains(lowecaseText) ||
            coin.id.lowercased().contains(lowecaseText)
        }
    }

    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []

        guard let data = marketDataModel else {
            return stats
        }

        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticsModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])

        return stats
    }

    private func validatePortfolioSaveState(coin: CoinModel?, text: String) -> Bool {
        coin != nil && !text.isEmpty
    }
}
