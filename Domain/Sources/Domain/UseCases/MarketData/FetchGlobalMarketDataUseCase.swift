//
//  FetchGlobalMarketData.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Combine
import Foundation
import Network
import Model
import ShortcutFoundation

public protocol IFetchGlobalMarketDataUseCase {
    func execute() -> AnyPublisher<MarketDataModel?, RequestError>
}

public class FetchGlobalMarketDataUseCase: IFetchGlobalMarketDataUseCase {
    @LazyInject private(set) var marketDataRepository: IMarketDataRepository

    public init() { }

    public func execute() -> AnyPublisher<MarketDataModel?, RequestError> {
        marketDataRepository.fetchGlobalMarketData()
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
