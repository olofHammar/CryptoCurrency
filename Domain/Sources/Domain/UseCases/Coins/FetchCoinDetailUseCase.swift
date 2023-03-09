//
//  FetchCoinDetailUseCase.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-09.
//

import Combine
import Foundation
import Network
import Model
import ShortcutFoundation

public protocol IFetchCoinDetailUseCase {
    func execute(with coinID: String) -> AnyPublisher<CoinDetailModel, RequestError>
}

public class FetchCoinDetailUseCase: IFetchCoinDetailUseCase {
    @LazyInject private(set) var coinsRepository: ICoinsRepository

    public init() { }

    public func execute(with coinID: String) -> AnyPublisher<CoinDetailModel, RequestError> {
        coinsRepository.getCoinDetail(for: coinID)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
