//  Ikigai
//  Theme.swift
//  Created by SAHIL KHATRI on 16/06/25.
//

import SwiftUI

// This extension allows us to initialize a Color directly from a HEX string.
// It's a handy utility to have in any project.
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


// Here we define all the colors from your theme guide.
// This keeps our branding consistent and easy to manage.
enum Theme {
    static let primary = Color(hex: "#FFADAD")     // Peachy Pink
    static let secondary = Color(hex: "#A0C49D")   // Wasabi Green
    static let accent = Color(hex: "#FFF89A")      // Sunrise Yellow
    static let background = Color(hex: "#FDF6EC")  // Paper White
    static let text = Color(hex: "#2F2F2F")         // Charcoal
}
