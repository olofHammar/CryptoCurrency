//
//  FetchAllSupportedCoinsUseCase.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Network
import Model
import ShortcutFoundation

public protocol IFetchAllSupportedCoinsUseCase {
    func execute() -> AnyPublisher<[CoinModel], RequestError>
}

public class FetchAllSupportedCoinsUseCase: IFetchAllSupportedCoinsUseCase {
    @LazyInject private(set) var coinsRepository: ICoinsRepository

    public init() { }

    public func execute() -> AnyPublisher<[CoinModel], RequestError> {
        coinsRepository.getAllSupportedCoins()
            .eraseToAnyPublisher()
    }
}
