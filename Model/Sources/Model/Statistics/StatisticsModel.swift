//
//  StatisticsModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Foundation

public struct StatisticsModel: Identifiable {
    public let id = UUID().uuidString
    public let title: String
    public let value: String
    public let percetageChange: Double?

    public init(
        title: String,
        value: String,
        percentageChange: Double? = nil
    ) {
        self.title = title
        self.value = value
        self.percetageChange = percentageChange
    }
}

public extension StatisticsModel {
    static let mockModel1 = StatisticsModel(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34)
    static let mockModel2 = StatisticsModel(title: "Total Volume", value: "$1.23Tr")
    static let mockModel3 = StatisticsModel(title: "Other Data", value: "$143.23m")
    static let mockModel4 = StatisticsModel(title: "Portfolio Value", value: "$50.4k", percentageChange: -12.34)
}
