//
//  CoinDetailView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Model
import SwiftUI

struct CoinDetailView: View {

    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
        print("initialising view for \(coin.name)")
    }

    var body: some View {
        VStack {
            Text(coin.name)
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: .mockCoin)
    }
}
