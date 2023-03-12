//
//  MarketDataModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Foundation

public struct GlobalData: Codable {
    public let data: MarketDataModel?
}

public struct MarketDataModel: Codable {
    public let totalMarketCap: [String: Double]
    public let totalVolume: [String: Double]
    public let marketCapPercentage: [String: Double]
    public let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }

    public var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return "N/A"
    }

    public var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return "N/A"
    }

    public var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentageString()
        }
        return "N/A"
    }
}

public extension Double {
    func asNumberString() -> String {
        return String(format: "%.1f", self)
    }

    func asPercentageString() -> String {
        return asNumberString() + "%"
    }

    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_00
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"

        case 1_000_000_000...:
            let formatted = num / 1_000_000_00
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"

        case 1_000_000...:
            let formatted = num / 1_000_00
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"

        case 1_000...:
            let formatted = num / 1_00
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
            
        case 0...:
            let stringFormatted = String(format: "%.1f", (self * 10))
            return  "\(sign)\(stringFormatted)kr"

        default:
            return "\(sign)\(self)"
        }
    }
}
