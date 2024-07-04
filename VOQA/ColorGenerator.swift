//
//  ColorGenerator.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation
import SwiftUI

class ColorGenerator: ObservableObject {
    @Published var dominantBackgroundColor: Color = .black // Default color
    @Published var sharpContrastColor: Color = .teal // Default color for sharp contrast
    @Published var dominantDarkToneColor: Color = .black.opacity(0.6) // Default for dominant dark tone
    @Published var dominantLightToneColor: Color = Color.themePurple
    @Published var secondaryColor: Color = .red
    @Published var enhancedDominantColor: Color = .mint
    
    func updateDominantColor(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName),
                  let dominantColor = image.dominantColor() else { return }
            
            DispatchQueue.main.async {
                self.dominantBackgroundColor = Color(dominantColor)
            }
        }
    }
    
    func updateSharpContrastColor(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName),
                  let contrastColor = image.sharpContrastColor() else { return }
            
            DispatchQueue.main.async {
                self.sharpContrastColor = Color(contrastColor)
            }
        }
    }
    
    func updateDominantDarkTone(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName),
                  let darkToneColor = image.dominantDarkTone() else { return }
            
            DispatchQueue.main.async {
                self.dominantDarkToneColor = Color(darkToneColor)
            }
        }
    }
    
    func updateDominantLightTone(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName),
                  let lightToneColor = image.dominantLightTone() else { return }
            
            DispatchQueue.main.async {
                self.dominantLightToneColor = Color(lightToneColor)
            }
        }
    }
    
    func updateEnhancedDominantColor(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName),
                  let enhancedColor = image.enhancedDominantColor() else { return }
            
            DispatchQueue.main.async {
                self.enhancedDominantColor = Color(enhancedColor)
            }
        }
    }
    
    func updateAllColors(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName) else { return }
            
            let dominantColor = image.dominantColor()
            let contrastColor = image.sharpContrastColor()
            let darkToneColor = image.dominantDarkTone()
            let lightToneColor = image.dominantLightTone()
            let secondaryColor = image.secondaryColor()
            let enhancedColor = image.enhancedDominantColor()
            
            DispatchQueue.main.async {
                if let dominantColor = dominantColor {
                    self.dominantBackgroundColor = Color(dominantColor)
                }
                if let contrastColor = contrastColor {
                    self.sharpContrastColor = Color(contrastColor)
                }
                if let darkToneColor = darkToneColor {
                    self.dominantDarkToneColor = Color(darkToneColor)
                }
                if let lightToneColor = lightToneColor {
                    self.dominantLightToneColor = Color(lightToneColor)
                }
                if let secondaryColor = secondaryColor {
                    self.secondaryColor = Color(secondaryColor)
                }
                if let enhancedColor = enhancedColor {
                    self.enhancedDominantColor = Color(enhancedColor)
                }
            }
        }
    }
}
