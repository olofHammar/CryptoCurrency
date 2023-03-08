//
//  MarketDataDataSource.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Foundation
import Model

public struct MarketDataDataSource: HTTPClient, IMarketDataDataSource {

    public init() { }

    public func fetchGlobalMarketData() async -> Result<GlobalData, RequestError> {
        return await sendRequest(endpoint: MarketDataEndPoint.fetchGlobalMarketData, responseModel: GlobalData.self)
    }
}
