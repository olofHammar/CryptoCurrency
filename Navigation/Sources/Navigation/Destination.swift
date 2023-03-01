//
//  Destination.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import SwiftUI

/// Enumeration of possible specific destinations in this app.
public enum Destination: NavigationStackable {
    case root
    case dashboard
    case coinDetail
    case profile
}

/// The navigator specific for this project
public typealias AppNavigator = Navigator<Destination>
