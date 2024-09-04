//
//  View+Extensions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI

extension View {
    func signInButtonStyle() -> some View {
        self.overlay(
            Capsule(style: .continuous)
                .stroke(Color.white, lineWidth: 2)
        )
        .clipShape(Capsule())
        .frame(height: 45)
    }
    
    func dynamicExactGradientBackground(startColor: Color, endColor: Color) -> some View {
        let startPoint = UnitPoint(x: 0.49999998837676157, y: 2.9479518284275417e-15)
        let endPoint = UnitPoint(x: 0.4999999443689973, y: 0.9363635917143408)
        
        return self.background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                                              startPoint: startPoint,
                                              endPoint: endPoint))
    }
    
    func primaryTextStyleForeground() -> some View {
        self.foregroundStyle(
            LinearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as?
                         UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            
            return 0
        }
        
        return 0
    }
    
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func activeGlow(_ color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
    }
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func labelStyle() -> some View {
        self
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .foregroundStyle(.white)
    }
    
    func scoreStyle() -> some View {
        self
            .foregroundStyle(.purple)
            .font(.system(size: 18))
            .fontWeight(.bold)
    }
    
    func backgroundStyle() -> some View {
        self
            .padding()
            .background(Color.gray.opacity(0.06))
    }
    
    func lightBackgroundStyle() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Material.ultraThin)
                .environment(\.colorScheme, .light)
                .padding()
        )
    }
}
