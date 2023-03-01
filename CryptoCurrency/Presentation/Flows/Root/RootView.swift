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
        Group {
            TabBarView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
