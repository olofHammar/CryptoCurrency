//
//  IMarketDataDataSource.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//
import Foundation
import Model

public protocol IMarketDataDataSource {
    func fetchGlobalMarketData() async -> Result<GlobalData, RequestError>
}
