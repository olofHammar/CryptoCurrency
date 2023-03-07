//
//  CoinImageViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-02.
//

import Combine
import Domain
import Model
import ShortcutFoundation
import SwiftUI

final class CoinImageViewModel: ObservableObject {
    @Inject private var fetchCoinImageUseCase: IFetchCoinImagesUseCase

    @Published var image: UIImage?
    @Published var isLoading = false

    private let coin: CoinModel
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.isLoading = true
        self.coin = coin
        startObservingImage()
    }

    private func startObservingImage() {
        fetchCoinImageUseCase.execute(with: coin.image)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] (image) in
                self?.image = image
            }
            .store(in: &cancellables)
    }
}
