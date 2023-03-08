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

final class DashboardViewModel: ObservableObject {
    @Inject private var fetchAllSupportedCoinsUseCase: IFetchAllSupportedCoinsUseCase

    @Published private(set) var allAvailableCoins: [CoinModel] = []
    @Published private(set) var coinsList: [CoinModel] = []
    @Published private(set) var portfolioCoins: [CoinModel] = []

    @Published private(set) var isLoading = false
    @Published var isPresentingPortfolio = false

    @Published var searchText = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        isLoading = true
        startObservingCoins()
    }

    func togglePortfolioState() {
        isPresentingPortfolio.toggle()
    }

    func shouldDisplayPortfolioEmptyState() -> Bool {
        portfolioCoins.isEmpty
    }

    func shouldDisplayAllCoinsEmptyState() -> Bool {
        coinsList.isEmpty
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

        $coinsList
            .map { coinList -> [CoinModel] in
                coinList.filter { $0.currentHoldings != nil }
            }
            .receive(on: RunLoop.main)
            .assign(to: &$portfolioCoins)

        $searchText
            .combineLatest($allAvailableCoins)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map(filteredCoinsList)
            .receive(on: RunLoop.main)
            .assign(to: &$coinsList)
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
}
