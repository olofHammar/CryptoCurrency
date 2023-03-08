//
//  UIApplication+Keyboard.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-08.
//

import Foundation
import SwiftUI

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
