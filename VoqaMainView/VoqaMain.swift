//
//  VoqaMain.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/8/24.
//

import SwiftUI

struct VoqaMain: View {
    var body: some View {
        HomePage()
            .tint(.white).activeGlow(.white, radius: 2)
    }
}


struct PerformanceView: View {
    var body: some View {
        Text("Placeholder Performance View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Placeholder Profile View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}


struct TabIcons: View {
    var title: String
    var icon: String
    
    var body: some View {
        // Tab Icons content here
        Label(title, systemImage: icon)
    }
}


#Preview {
    VoqaMain()
        .preferredColorScheme(.dark)
}

struct VoqaBackground: View {
    var body: some View {
        Image("Icon")
            .resizable()
            .frame(width: 700, height: 800)
            .offset(x: -180)
            .blur(radius: 3.0)
    }
}


struct BackgroundView: View {
    var backgroundImage: String
    var color: Color
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 300)
            .background(
                LinearGradient(gradient: Gradient(colors: [color, .black]), startPoint: .top, endPoint: .bottom)
            )
            .overlay {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .frame(height: 300)
            .blur(radius: 100)
    }
}




extension View {
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
}

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





