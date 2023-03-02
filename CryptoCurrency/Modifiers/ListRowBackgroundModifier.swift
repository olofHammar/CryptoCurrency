//
//  ListRowBackgroundModifier.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-02.
//

import SwiftUI

struct ListRowBackgroundModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .listRowBackground(color)
    }
}
