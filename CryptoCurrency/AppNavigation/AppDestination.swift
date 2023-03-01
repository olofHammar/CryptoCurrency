//
//  AppDestination.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import Navigation
import SwiftUI

/// Entity to navigate between views (screens) in the app.
/// Main one, that takes into account the type of possible specific destinations in this app.
typealias MainNavigatior = DefaultNavigator<AppDestination>
