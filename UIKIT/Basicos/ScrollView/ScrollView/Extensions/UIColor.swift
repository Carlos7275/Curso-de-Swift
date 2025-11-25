//
//  UIColor.swift
//  ScrollView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//
import Foundation
import UIKit

extension UIColor {
    var toHex: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        // Convierte usando el espacio RGB
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255)

        return String(format: "#%06X", rgb)
    }
}
