//
//  ICoinsRepository.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model
import Network
import ShortcutFoundation
import UIKit

public protocol ICoinsRepository {
    func getAllSupportedCoins() -> AnyPublisher<[CoinModel], RequestError>
    func getCoinImage(from urlString: String) -> AnyPublisher<UIImage, RequestError>
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

    public func getCoinImage(from urlString: String) -> AnyPublisher<UIImage, RequestError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let image = UIImage(data: data) else {
                    throw RequestError.noResponse
                }
                return image
            }
            .mapError { error in
                return RequestError.unknown
            }
            .eraseToAnyPublisher()
    }

}
