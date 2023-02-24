//
//  CoinDataSource.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model

public struct CoinDataSource: HTTPClient, ICoinDataSource {

    public init() { }

    public func getAllSupportedCoins() async -> Result<[CoinModel], RequestError> {
        return await sendRequest(endpoint: CoinsEndPoint.allSupportedCoins(currency: .sek, order: .marketCapDesc, itemsPerPage: 250, sparkline: true),
                                 responseModel: [CoinModel].self)
    }
}
