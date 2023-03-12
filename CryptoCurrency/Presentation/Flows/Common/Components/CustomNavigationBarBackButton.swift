//
//  CustomNavigationBarBackButton.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-12.
//

import Navigation
import ShortcutFoundation
import SwiftUI

struct CustomNavigationBarBackButtonView: View {

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "chevron.left")

            Text("Back")
        }
        .foregroundColor(.theme.textColor)
        .font(.textStyle.smallText)
    }
}

private struct CustomNavigationBarBackButton: View {
    @InjectObject private var navigator: AppNavigator

    var body: some View {
        Button(action: goBack) {
            CustomNavigationBarBackButtonView()
        }
    }

    private func goBack() {
        navigator.pop()
    }
}

struct CustomNavigationBarBackButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavigationBarBackButtonView()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 300, alignment: .topLeading)
        .background(Color.theme.backgroundColor)
    }
}

extension View {
    func customNavigationBarBackButton() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomNavigationBarBackButton()
                }
            }
    }
}
