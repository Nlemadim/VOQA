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
