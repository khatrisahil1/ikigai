//
//  Theme.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import SwiftUI

// This extension for Color(hex:) remains the same.
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


enum Theme {
    static let primary = Color(hex: "#FFADAD")     // Peachy Pink
    static let secondary = Color(hex: "#A0C49D")   // Wasabi Green
    static let accent = Color(hex: "#FFF89A")      // Sunrise Yellow
    static let background = Color(hex: "#FDF6EC")  // Paper White
    static let text = Color(hex: "#2F2F2F")         // Charcoal
    
    // --- NEW: A predefined array of colors for different levels ---
    static let levelColors: [Color] = [
        Theme.secondary, // Level 1 starts with our Wasabi Green
        .blue,
        .purple,
        .pink,
        .orange,
        .indigo,
        .teal
    ]
    
    // --- NEW: A helper function to safely get a color for any level ---
    // It cycles through the colors if the user's level exceeds the number of colors in our array.
    static func color(for level: Int) -> Color {
        // We use (level - 1) because arrays are 0-indexed.
        let index = (level - 1) % levelColors.count
        return levelColors[index]
    }
}
