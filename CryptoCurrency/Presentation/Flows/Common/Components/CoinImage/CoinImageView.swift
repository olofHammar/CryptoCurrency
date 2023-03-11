//
//  CoinImageView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-02.
//

import Model
import SwiftUI

struct CoinImageView: View {

    @StateObject var vm: CoinImageViewModel

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }

    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .saturation(0)
                    .colorMultiply(.theme.lightBlue)
                    .shadow(radius: 2, x: 2, y: 2)

            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryColor)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: CoinModel.mockCoin)
    }
}
