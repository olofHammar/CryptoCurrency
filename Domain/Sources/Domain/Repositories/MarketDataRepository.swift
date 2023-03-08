//
//  MarketDataRepositry.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model
import Network
import ShortcutFoundation

public protocol IMarketDataRepository {
    func fetchGlobalMarketData() -> AnyPublisher<MarketDataModel?, RequestError>
}

public class MarketDataRepository: IMarketDataRepository {
    @LazyInject private(set) var marketDataDataSource: IMarketDataDataSource

    public init() { }

    public func fetchGlobalMarketData() -> AnyPublisher<MarketDataModel?, RequestError> {
        return Future { promise in
            Task {
                let result = await self.marketDataDataSource.fetchGlobalMarketData()

                switch result {
                case .success(let dataModel):
                    promise(.success(dataModel.data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
