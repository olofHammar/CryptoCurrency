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

    @Published private(set) var coinsList: [CoinModel] = []
    @Published private(set) var portfolioCoins: [CoinModel] = []

    @Published var isPresentingPortfolio = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        startObservingCoins()
    }

    func togglePortfolioState() {
        isPresentingPortfolio.toggle()
    }

    private func startObservingCoins() {
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
                self.coinsList = coins
            }
            .store(in: &cancellables)
    }
}
