//
//  File.swift
//  
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model
import Network
import ShortcutFoundation

public protocol ICoinsRepository {
    func getAllSupportedCoins() -> AnyPublisher<[CoinModel], RequestError>
}

public class CoinsRepository: ICoinsRepository {
    @LazyInject private(set) var coinDataSource: ICoinDataSource

    public init() { }

    public func getAllSupportedCoins() -> AnyPublisher<[CoinModel], RequestError> {
        return Future { promise in
            Task {
                let result = await self.coinDataSource.getAllSupportedCoins()

                switch result {
                case .success(let coins):
                    promise(.success(coins))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
