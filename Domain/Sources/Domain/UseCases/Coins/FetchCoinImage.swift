//
//  FetchCoinImageUseCase.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model
import ShortcutFoundation
import UIKit

public protocol IFetchCoinImagesUseCase {
    func execute(with coin: CoinModel) -> AnyPublisher<UIImage, RequestError>
}

public class FetchCoinImageUseCase: IFetchCoinImagesUseCase {
    @LazyInject private(set) var coinsRepository: ICoinsRepository

    public init() { }

    public func execute(with coin: CoinModel) -> AnyPublisher<UIImage, RequestError> {
        if let image = coinsRepository.getCachedImage(for: coin) {
            return Just(image)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }

        return coinsRepository.downloadImage(for: coin)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
