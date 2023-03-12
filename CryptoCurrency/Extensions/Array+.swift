//
//  Array+.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-12.
//

import Foundation

extension Array where Element: Comparable {

    func chartStats() -> [Element] {
        guard let min = self.min(), let max = self.max(), self.count > 1 else {
            return []
        }
        let sorted = self.sorted()
        let nextLowest = sorted.firstIndex(of: max).flatMap { index in index > 0 ? sorted[index - 1] : nil }
        let nextHighest = sorted.firstIndex(of: min).flatMap { index in index < sorted.count - 1 ? sorted[index + 1] : nil }
        return [min, nextLowest, nextHighest, max].compactMap { $0 }
    }
}
