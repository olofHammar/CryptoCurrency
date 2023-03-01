//
//  DashboardView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Navigation
import ShortcutFoundation
import SwiftUI

struct DashboardView: View {
    @State private var isPresentingPortfolio = false

    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView()

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 0) {
            CircleButtonView(iconName: isPresentingPortfolio ? "plus" : "info")
                .animation(.none, value: isPresentingPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $isPresentingPortfolio)
                        .foregroundColor(.theme.lightGray)
                )

            Spacer()

            Text(isPresentingPortfolio ? "Portfolio" : "Live Prices")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.theme.textColor)
                .animation(.none)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: isPresentingPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        isPresentingPortfolio.toggle()
                    }
                }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
