//
//  CircleButtonAnimationView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-01.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 3.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: animate)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
    }
}
