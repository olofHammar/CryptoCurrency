//
//  CryptoCurrencyApp.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Navigation
import ShortcutFoundation
import SwiftUI

@main
struct CryptoCurrencyApp: App {

    private let context = Context(AppConfig())

    @InjectObject private var navigator: AppNavigator

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : UIColor(Color.theme.textColor),
            .font : UIFont(name: "KohinoorTelugu-Medium", size: 32)!
        ]

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor : UIColor(Color.theme.textColor),
            .font : UIFont(name: "KohinoorTelugu-Medium", size: 16)!
        ]

        UINavigationBar.appearance().tintColor = UIColor(Color.theme.textColor)
    }

    var body: some Scene {
        WindowGroup {
            navigator.rootView
        }
    }
}
