//
//  String+.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-10.
//

import Foundation

extension Date {

    init(coinGeckoString: String) {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }

    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
//        formatter.dateStyle = .short
        formatter.dateFormat = "d MMM"
        return formatter
    }

    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
