//
//  RootViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Domain
import Model
import ShortcutFoundation
import SwiftUI

final class RootViewModel: ObservableObject {
    @Inject private var fetchAllSupportedCoinsUseCase: IFetchAllSupportedCoinsUseCase
    @Published private(set) var coinsList: [CoinModel] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
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
