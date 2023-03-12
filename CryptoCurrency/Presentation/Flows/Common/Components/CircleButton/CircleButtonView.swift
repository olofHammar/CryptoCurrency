//
//  CircleButtonView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    let color: Color = .theme.backgroundColor

    var body: some View {
        Image(systemName: iconName)
            .font(.textStyle.mediumText)
            .foregroundColor(Color.theme.textColor)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(color)
            )
            .shadow(
                color: .theme.shadow,
                radius: 4, x: 0, y: 0
            )
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "chevron.left")
    }
}
