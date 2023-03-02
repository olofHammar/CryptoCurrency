//
//  Double+Formatter.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Foundation

extension Double {

    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter
    }

    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "N/A"
    }

    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6

        return formatter
    }

    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "N/A"
    }

    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }

    func asPercentageString() -> String {
        return asNumberString() + "%"
    }
}
