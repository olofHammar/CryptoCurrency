//
//  StaticMarketDataDataSource.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Combine
import Foundation
import Model

public struct StaticMarketDataDataSource: IMarketDataDataSource {

    public init() { }

    public func fetchGlobalMarketData() async -> Result<GlobalData, RequestError> {
        do {
            let result: GlobalData = try locationsFromJsonFixture("MarketData")
            return .success(result)

        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(.invalidURL)
        }
    }
}

private func locationsFromJsonFixture(_ resourceName: String) throws -> GlobalData {
    guard let url = Bundle.module.url(forResource: resourceName, withExtension: "json") else {
        throw RequestError.invalidURL
    }

    let data = try Data(contentsOf: url)

    let decoder = JSONDecoder()
    return try decoder.decode(GlobalData.self, from: data)
}
