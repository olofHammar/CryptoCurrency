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

    var body: some Scene {
        WindowGroup {
            navigator.rootView
        }
    }
}
