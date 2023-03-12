//
//  String+.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-12.
//

import SwiftUI

extension String {
    static var fontName: String = "Kailasa"
}

struct Font_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Live Prices")
                .font(.textStyle.title)

            Text("Bitcoin")
                .font(.textStyle.mediumText)

            Text("BTC")
                .font(.textStyle.smallText)
                .bold()

            Text("200,00,01")
                .font(.textStyle.mediumText)
        }
    }
}
