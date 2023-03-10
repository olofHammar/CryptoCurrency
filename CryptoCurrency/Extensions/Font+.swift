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
    let title: Font = .custom("Futura", size: 32)
    let subtitle: Font = .custom("Futura", size: 24)
    let largeText: Font = .custom("Futura", size: 18)
    let mediumText: Font = .custom("Futura", size: 16)
    let smallText: Font = .custom("Futura", size: 14)
    let smallestText: Font = .custom("Futura", size: 12)
    let graphText: Font = .custom("Futura", size: 10)
}
