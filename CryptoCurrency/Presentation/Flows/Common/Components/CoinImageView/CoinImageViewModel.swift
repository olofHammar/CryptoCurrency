//
//  CoinImageViewModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-02.
//

import SwiftUI

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
}
