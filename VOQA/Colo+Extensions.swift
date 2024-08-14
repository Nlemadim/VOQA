//
//  Colo+Extensions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI


extension Color {
    /// Calculates the luminance of the color, a measure of the perceived brightness.
    func luminance() -> Double {
        // Convert the Color to a UIColor instance to access its components
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract RGBA components from the UIColor instance
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate the luminance using the formula provided
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    /// Returns a color that contrasts with the color instance it is called on,
    /// providing black or white text color depending on the luminance of the background color.
    func dynamicTextColor() -> Color {
        // Check the luminance and return either black or white color
        return self.luminance() > 0.5 ? .black : .white
    }
    
    static func fromHex(_ hex: String, alpha: Double = 1.0) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let length = hexSanitized.count
        var r, g, b: Double
        switch length {
        case 3: // #RGB
            (r, g, b) = (
                Double((rgb & 0xF00) >> 8) / 15.0,
                Double((rgb & 0x0F0) >> 4) / 15.0,
                Double(rgb & 0x00F) / 15.0
            )
        case 6: // #RRGGBB
            (r, g, b) = (
                Double((rgb & 0xFF0000) >> 16) / 255.0,
                Double((rgb & 0x00FF00) >> 8) / 255.0,
                Double(rgb & 0x0000FF) / 255.0
            )
        default:
            // Return a default color if the hex code is invalid
            return Color.clear
        }
        
        return Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

extension UIColor {
    /// Helper function to convert RGB to HSB
    func hsbColor() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        }
        return nil
    }
}
