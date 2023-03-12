//
//  Font+.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import SwiftUI

extension Font {
    static let textStyle = TextScheme()
}

struct TextScheme {
    let title: Font = .custom(String.fontName, size: 32)
    let subtitle: Font = .custom(String.fontName, size: 24)
    let largeText: Font = .custom(String.fontName, size: 18)
    let mediumText: Font = .custom(String.fontName, size: 16)
    let smallText: Font = .custom(String.fontName, size: 14)
    let smallestText: Font = .custom(String.fontName, size: 12)
    let graphText: Font = .custom(String.fontName, size: 10)
}
