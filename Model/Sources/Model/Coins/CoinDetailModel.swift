//
//  CoinModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-09.
//

import Foundation

public struct CoinDetailModel: Codable {
    public let id: String
    public let symbol: String
    public let name: String
    public let blockTimeInMinutes: Int?
    public let hashingAlgorithm: String?
    public let categories: [String]?
    public let description: Description?
    public let links: Links?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case description, links
    }
}

public struct Description: Codable {
    public let en: String?
}

public struct Links: Codable {
    public let homepage: [String]?
    public let subredditURL: String?

    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}
