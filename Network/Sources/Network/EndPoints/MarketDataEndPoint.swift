//
//  MarketDataEndPoint.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Foundation
import Model

public enum MarketDataEndPoint {
    case fetchGlobalMarketData
}

extension MarketDataEndPoint: Endpoint {
    public var path: String {
        switch self {
        case .fetchGlobalMarketData:
            return "/api/v3/global"
        }
    }

    public var method: RequestMethod {
        switch self {
        case .fetchGlobalMarketData:
            return .get
        }
    }

    public var header: [String: String]? {
        switch self {
        case .fetchGlobalMarketData:
            return nil
        }
    }

    public var body: [String: String]? {
        switch self {
        case .fetchGlobalMarketData:
            return nil
        }
    }

    public var queryItems: [URLQueryItem] {
        switch self {
        case .fetchGlobalMarketData:
            return []
        }
    }
}
