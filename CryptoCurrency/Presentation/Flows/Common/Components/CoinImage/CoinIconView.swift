//
//  CoinIconView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Model
import SwiftUI

struct CoinIconView: View {

    let coin: CoinModel

    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)

            Text(coin.name)
                .font(.textStyle.smallText)
                .fontWeight(.semibold)
                .foregroundColor(.theme.lightGray)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }

    }
}

struct CoinIconView_Previews: PreviewProvider {
    static var previews: some View {
        CoinIconView(coin: .mockCoin)
            .preferredColorScheme(.dark)
    }
}
