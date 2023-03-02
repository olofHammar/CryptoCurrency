//
//  CoinDataSource.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Combine
import Foundation
import Model

public struct StaticCoinDataSource: ICoinDataSource {

    public init() { }

    public func getAllSupportedCoins() async -> Result<[CoinModel], RequestError> {
        do {
            let result: [CoinModel] = try locationsFromJsonFixture("CoinData")
            return .success(result)

        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(.invalidURL)
        }
    }
}

private func locationsFromJsonFixture(_ resourceName: String) throws -> [CoinModel] {
    guard let url = Bundle.module.url(forResource: resourceName, withExtension: "json") else {
        throw RequestError.invalidURL
    }

    let data = try Data(contentsOf: url)

    let decoder = JSONDecoder()
    return try decoder.decode([CoinModel].self, from: data)
}
