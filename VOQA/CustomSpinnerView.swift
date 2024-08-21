//
//  CustomSpinnerView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/14/24.
//

import SwiftUI

struct CustomSpinnerView: View {
    @State private var isAnimating = false
    
    let numberOfDots = 8
    let dotSize: CGFloat = 12
    let animationDuration: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let circleRadius = min(geometry.size.width, geometry.size.height) / 2 - dotSize / 2
            let angleStep = 2 * .pi / CGFloat(numberOfDots)
            
            ZStack {
                ForEach(0..<numberOfDots, id: \.self) { index in
                    Circle()
                        .fill(Color.teal)
                        .frame(width: dotSize, height: dotSize)
                        .scaleEffect(isAnimating ? 1 : 0.1)
                        .opacity(isAnimating ? 1 : 0.3)
                        .offset(x: circleRadius * cos(angleStep * CGFloat(index)),
                                y: circleRadius * sin(angleStep * CGFloat(index)))
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.easeInOut(duration: animationDuration)
                                .repeatForever(autoreverses: true)
                                .delay(animationDuration / Double(numberOfDots) * Double(index)),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                isAnimating = true
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    CustomSpinnerView()
}
