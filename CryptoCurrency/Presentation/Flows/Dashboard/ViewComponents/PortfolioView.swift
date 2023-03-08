//
//  PortfolioView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import SwiftUI

struct PortfolioView: View {

    @ObservedObject var vm: DashboardViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Title")
            }
            .navigationBarTitle("Edit Portfolio")
        }
        .navigationBarTitle("Edit Portfolio")
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(vm: DashboardViewModel())
    }
}
