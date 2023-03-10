//
//  DashboardViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Combine
import Domain
import Foundation
import Navigation
import Model
import ShortcutFoundation
import SwiftUI

final class DashboardViewModel: ObservableObject {
    @InjectObject private var navigator: AppNavigator
    @Inject var portfolioDataService: PortfolioDataService
    @Inject private var fetchAllSupportedCoinsUseCase: IFetchAllSupportedCoinsUseCase
    @Inject private var fetchGlobalMarketDataUseCase: IFetchGlobalMarketDataUseCase

    @Published private(set) var marketDataModel: MarketDataModel?
    @Published private(set) var statistics: [StatisticsModel] = []
    @Published private(set) var allAvailableCoins: [CoinModel] = []
    @Published private(set) var coinsList: [CoinModel] = []
    @Published private(set) var portfolioCoins: [CoinModel] = []
    @Published private(set) var selectedCoin: CoinModel?
    @Published var selectedSortOption: SortOption = .rank

    @Published private(set) var isLoading = false
    @Published var isPresentingPortfolio = false
    @Published private(set) var isPresentingSearchBar = false
    @Published var isPresentingPortfolioSheet = false
    @Published var shouldPresentSavePortfolioButton = false

    @Published var searchText = ""
    @Published var quantityText = ""

    private var cancellables = Set<AnyCancellable>()

    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }

    init() {
        isLoading = true
        fetchAllCoins()
        fetchMarketData()
        startObservingCoins()
        startObservingMarketData()
        startObservingViewStates()
    }

    func togglePortfolioState() {
        isPresentingPortfolio.toggle()
    }

    func presentPortfolioSheet() {
        guard isPresentingPortfolio else {
            withAnimation {
                isPresentingSearchBar.toggle()
            }
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

    func shouldDisplayPortfolioCoins() -> Bool {
        selectedCoin == nil && searchText.isEmpty
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

    func reloadData() {
        fetchAllCoins()
        fetchMarketData()
    }

    func isSortedByRank() -> Bool {
        selectedSortOption == .rank || selectedSortOption == .rankReversed
    }

    func isSortedByHoldings() -> Bool {
        selectedSortOption == .holdings || selectedSortOption == .holdingsReversed
    }

    func isSortedByPrice() -> Bool {
        selectedSortOption == .price || selectedSortOption == .priceReversed
    }

    func navigateToCoinDetail(with coin: CoinModel) {
        navigator.push(.coinDetail(coin))
    }

    private func fetchAllCoins() {
        fetchAllSupportedCoinsUseCase.execute()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { coins in
                self.allAvailableCoins = coins
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    private func fetchMarketData() {
        fetchGlobalMarketDataUseCase.execute()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching market data: \(error)")
                }
            } receiveValue: { globalMarketData in
                self.marketDataModel = globalMarketData
            }
            .store(in: &cancellables)
    }

    private func startObservingCoins() {

        $searchText
            .combineLatest($allAvailableCoins, $selectedSortOption)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map(filterAndSortCoins)
            .receive(on: RunLoop.main)
            .assign(to: &$coinsList)

        $coinsList
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .receive(on: RunLoop.main)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
    }

    private func startObservingMarketData() {

        $marketDataModel
            .combineLatest($portfolioCoins)
            .compactMap(mapGlobalMarketData)
            .receive(on: RunLoop.main)
            .assign(to: &$statistics)
    }

    private func startObservingViewStates() {
        $selectedCoin
            .combineLatest($quantityText)
            .compactMap(validatePortfolioSaveState)
            .receive(on: RunLoop.main)
            .assign(to: &$shouldPresentSavePortfolioButton)
    }

    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var updatedCoins = filteredCoinsList(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
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

    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank} )
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank} )
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice} )
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice} )
        }
    }

    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch selectedSortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue} )
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue} )
        default:
            return coins
        }
    }

    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []

        guard let data = marketDataModel else {
            return stats
        }

        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)

        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)

        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])

        return stats
    }

    private func validatePortfolioSaveState(coin: CoinModel?, text: String) -> Bool {
        coin != nil && !text.isEmpty
    }
}
