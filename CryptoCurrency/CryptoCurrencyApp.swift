//
//  CryptoCurrencyApp.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import ShortcutFoundation
import SwiftUI

@main
struct CryptoCurrencyApp: App {

    let context = Context(AppConfig())

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
