//
//  CoinsEndPoint.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Foundation
import Model

public enum CoinsEndPoint {
    case allSupportedCoins(currency: CurrencyIdentifier, order: Order, itemsPerPage: Int, sparkline: Bool)
}

extension CoinsEndPoint: Endpoint {
    public var path: String {
        switch self {
        case .allSupportedCoins:
            return "/api/v3/coins/markets"
        }
    }

    public var method: RequestMethod {
        switch self {
        case .allSupportedCoins:
            return .get
        }
    }

    public var header: [String: String]? {
        switch self {
        case .allSupportedCoins:
            return nil
        }
    }

    public var body: [String: String]? {
        switch self {
        case .allSupportedCoins:
            return nil
        }
    }

    public var queryItems: [URLQueryItem] {
        switch self {
        case .allSupportedCoins(let currency, let order, let itemsPerPage, let sparkline):
            return [
                URLQueryItem(name: "vs_currency", value: currency.rawValue),
                URLQueryItem(name: "order", value: order.rawValue),
                URLQueryItem(name: "per_page", value: String(itemsPerPage)),
                URLQueryItem(name: "sparkline", value: String(sparkline))
            ]
        }
    }
}

extension CoinsEndPoint {
    public enum Order: String {
        case marketCapDesc = "market_cap_desc"
        case geckoDeck = "gecko_desc"
        case geckoAsc = "gecko_asc"
        case marketCapAsc = "market_cap_asc"
        case volumeDesc = "volume_desc"
        case volumeAsc = "volume_asc"
        case idDesc = "id_desc"
        case idAsc = "id_asc"
    }
}
