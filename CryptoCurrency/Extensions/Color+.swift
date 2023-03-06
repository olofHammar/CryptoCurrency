//
//  Color+.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accentColor = Color("Colors/AccentColor")
    let backgroundColor = Color("Colors/BackgroundColor")
    let darkGray = Color("Colors/DarkGray")
    let green = Color("Colors/Green")
    let red = Color("Colors/Red")
    let lightGray = Color("Colors/LightGray")
    let lightGold = Color("Colors/LightGold")
    let darkGold = Color("Colors/DarkGold")
    let secondaryColor = Color("Colors/SecondaryColor")
    let textColor = Color("Colors/TextWhite")
}
