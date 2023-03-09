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
            let result: [CoinModel] = try coinsFromJsonFixture("CoinData")
            return .success(result)

        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(.invalidURL)
        }
    }

    public func getCoinDetail(for coinID: String) async -> Result<CoinDetailModel, RequestError> {
        do {
            let result: CoinDetailModel = try coinDetailFromJsonFixture("CoinDetailData")
            return .success(result)

        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(.invalidURL)
        }
    }
}

private func coinsFromJsonFixture(_ resourceName: String) throws -> [CoinModel] {
    guard let url = Bundle.module.url(forResource: resourceName, withExtension: "json") else {
        throw RequestError.invalidURL
    }

    let data = try Data(contentsOf: url)

    let decoder = JSONDecoder()
    return try decoder.decode([CoinModel].self, from: data)
}

private func coinDetailFromJsonFixture(_ resourceName: String) throws -> CoinDetailModel {
    guard let url = Bundle.module.url(forResource: resourceName, withExtension: "json") else {
        throw RequestError.invalidURL
    }

    let data = try Data(contentsOf: url)

    let decoder = JSONDecoder()
    return try decoder.decode(CoinDetailModel.self, from: data)
}
