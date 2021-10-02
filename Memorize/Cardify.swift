//
//  Cardify.swift
//  Memorize
//
//  Created by Андрей Гавриков on 01.10.2021.
//

import SwiftUI

struct Cardify: AnimatableModifier {

    var rotation: Double // in degrees
    var theme: RadialGradient
    
    init(isFaceUp: Bool, theme: RadialGradient) {
        rotation = isFaceUp ? 0 : 180
        self.theme = theme
    }
    
    var animatableData: Double {
        get {rotation}
        set {rotation = newValue}
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill(theme)
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
    
}

extension View {
    func cardify(isFaceUp: Bool, theme: RadialGradient) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, theme: theme))
    }
}
