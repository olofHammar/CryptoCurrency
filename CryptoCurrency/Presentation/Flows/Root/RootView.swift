//
//  RootView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var vm = RootViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(vm.coinsList) { coin in
                    Text(coin.name)
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
