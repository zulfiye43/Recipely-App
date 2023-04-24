//
//  Color+Extension.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// Hex to Color converter. Usage eg. Color(0x363CC)
extension Color {
    init(_ hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(.sRGB, red: components.R, green: components.G, blue: components.B, opacity: alpha)
    }
}

extension Color {
    
    static var primaryColor: Color {
        return Color(0xFC4069)
    }
    
    static var primaryLightColor: Color {
        return Color.init(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
    }
    
    static var primaryDarkColor: Color {
        return Color.black.opacity(0.8)
    }
}
