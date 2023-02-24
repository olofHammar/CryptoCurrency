//
//  IEndPoint.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Foundation
import Model

public protocol IEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var apiKey: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem] { get }
}

public extension IEndpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.coingecko.com/api/v3/coins"
    }
}
