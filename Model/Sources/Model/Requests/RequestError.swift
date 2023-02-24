//
//  CoinModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown

    public var customMessage: String {
        switch self {
        case .decode:
            return "Error: Couldn't decode data."
        case .invalidURL:
            return "Error: Invalid URL."
        case .noResponse:
            return "Error: No response."
        case .unauthorized:
            return "Error: Session expired"
        case .unexpectedStatusCode(let statusCode):
            return "Error: Status code: \(statusCode)"
        default:
            return "Unknown error"
        }
    }
}
