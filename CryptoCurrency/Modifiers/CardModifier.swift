//
//  CardModifier.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-07.
//

import SwiftUI

struct CardModifier: ViewModifier {
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let backgroundColor: Color
    let secondaryColor: Color

    init(
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 1,
        backgroundColor: Color = Color.theme.secondaryBackground,
        secondaryColor: Color = Color.theme.secondaryColor
    ) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.backgroundColor = backgroundColor
        self.secondaryColor = secondaryColor
    }

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    backgroundColor
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                    RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                .linearGradient(colors: [
                                    .theme.backgroundColor.opacity(0.4),
                                    .clear,
                                    .theme.backgroundColor.opacity(0.2),
                                    .theme.backgroundColor.opacity(0.5)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                        )
                }
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: shadowRadius, x: -shadowRadius, y: shadowRadius
                    )
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: shadowRadius, x: shadowRadius, y: -shadowRadius
                    )
            )
    }
}


struct CardModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                Text("Example card")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
            .modifier(CardModifier())
        }
        .background(Color.theme.backgroundColor)
    }
}
