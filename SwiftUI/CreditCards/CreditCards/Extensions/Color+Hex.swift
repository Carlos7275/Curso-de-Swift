//
//  Color+Hex.swift
//  CreditCards
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import SwiftUI

extension Color {
    static func hex(_ hex: String) -> Color {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned = cleaned.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        return Color(red: r, green: g, blue: b)
    }
}
