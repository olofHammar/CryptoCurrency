//
//  CapsuleButtonStyle.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Foundation

import SwiftUI

/// A custom button style that is used to display a button with a capsule shape. The button can be customized with size, color and font.
/// The button can also be disabled and display a loading animation.
public struct CapsuleButtonStyle: ButtonStyle {
    /// The selection of sizes available.
    public enum Size {
        case small
        case medium
        case large

        var height: CGFloat {
            switch self {
            case .small:
                return .x5

            case .medium:
                return .x6

            case .large:
                return .x7
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small:
                return .x4

            case .medium:
                return .x5

            case .large:
                return .x6
            }
        }
    }

    // TODO: Add more cases if needed. Add Asset catalog to package and update colors.
    /// The selection of color styles available.
    public enum ColorStyle {
        case darkBlue
        case custom(textColor: Color, backgroundColor: Color)

        var textColor: Color {
            switch self {
            case .darkBlue:
                return .white

            case .custom(let textColor, _):
                return textColor
            }
        }

        var backgroundColor: Color {
            switch self {
            case .darkBlue:
                return Color.theme.accentColor

            case .custom(_, let backgroundColor):
                return backgroundColor
            }
        }
    }

    /// The size of the button.
    private let size: Size
    /// The color style of the button.
    private let colorStyle: ColorStyle
    /// The font of the button label.
    private let font: Font
    /// A boolean value that determines whether the button is disabled.
    private let disabled: Bool
    /// A boolean value that determines whether the button is loading.
    private let isLoading: Bool
    /// A boolean value that determines whether the button should take up the full screen width.
    private let fullScreenWidth: Bool
    /// A boolean value that determines whether the button should display a shadow.
    private let hasShadow: Bool

    /// Creates a new instance of the button style.
    ///
    /// - Parameters:
    ///   - size: The size of the button. Default value is `.large`.
    ///   - colorStyle. The color style of the button. Default value is `.darkBlue`.
    ///   - font: The font of the button label. Default value is `.system(.headline, weight: .bold)`.
    ///   - disabled: A boolean value that determines wheter the button is disabled. Default value is `false`.
    ///   - isLoading: A boolean value that determines wheter the button is loading. Default value is `false`.
    ///   - fullScreenWidth: A boolean value that determines wheter the button should take up the full screen width. Default value is `false`.
    ///   - hasShadow: A boolean value that determines wheter the button should display a shadow. Default value is `false`.
    public init(
        size: Size = .large,
        colorStyle: ColorStyle = .darkBlue,
        font: Font = .system(.headline, weight: .bold),
        disabled: Bool = false,
        isLoading: Bool = false,
        fullScreenWidth: Bool = true,
        hasShadow: Bool = false
    ) {
        self.size = size
        self.colorStyle = colorStyle
        self.font = font
        self.disabled = disabled
        self.isLoading = isLoading
        self.fullScreenWidth = fullScreenWidth
        self.hasShadow = hasShadow
    }

    public func makeBody(configuration: Configuration) -> some View {
        Group {
            if isLoading {
                configuration.label
                    .hidden()
                    .overlay {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: colorStyle.textColor)
                            )
                    }
            } else {
                configuration.label
            }
        }
        .frame(maxWidth: fullScreenWidth ? .infinity : nil)
        .font(font)
        .frame(height: size.height)
        .padding(.horizontal, size.horizontalPadding)
        .foregroundColor(textColor)
        .background(
            Capsule(style: .circular)
                .foregroundColor(backgroundColor)
                .shadow(
                    color: disabled || !hasShadow ? .clear : .black.opacity(0.2),
                    radius: configuration.isPressed ? 0 : 3,
                    x: 0.0,
                    y: configuration.isPressed ? 0 : 3
                )
        )
    }

    private var textColor: Color {
        disabled ? .gray : colorStyle.textColor
    }

    private var backgroundColor: Color {
        disabled ? colorStyle.backgroundColor.opacity(0.5) : colorStyle.backgroundColor
    }
}

struct CapsuleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Default") { }
                .buttonStyle(
                    CapsuleButtonStyle()
                )

            Button("Test") { }
                .buttonStyle(
                    CapsuleButtonStyle(
                        size: .medium,
                        colorStyle: .custom(textColor: .yellow, backgroundColor: .red),
                        font: .system(size: 14, weight: .black),
                        disabled: false,
                        isLoading: false,
                        fullScreenWidth: false,
                        hasShadow: true
                    )
                )
        }
    }
}
