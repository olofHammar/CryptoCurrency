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
    let title: Font = .custom(String.fontMedium, size: 32)
    let titleBold: Font = .custom(String.fontBold, size: 32)
    let subtitle: Font = .custom(String.fontMedium, size: 24)
    let subtitleBold: Font = .custom(String.fontBold, size: 24)
    let largeText: Font = .custom(String.fontMedium, size: 18)
    let largeTextBold: Font = .custom(String.fontBold, size: 18)
    let mediumText: Font = .custom(String.fontMedium, size: 16)
    let mediumTextBold: Font = .custom(String.fontBold, size: 16)
    let smallText: Font = .custom(String.fontMedium, size: 14)
    let smallTextBold: Font = .custom(String.fontBold, size: 14)
    let smallestText: Font = .custom(String.fontMedium, size: 12)
    let smallestTextBold: Font = .custom(String.fontBold, size: 12)
    let graphText: Font = .custom(String.fontMedium, size: 10)
    let graphTextBold: Font = .custom(String.fontBold, size: 10)
}
