//
//  SupportLine.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

struct SupportLine: View {
    var color: Color!
    
    var body: some View {
        
        GeometryReader { geometry in
            
            Path { path in
                
                let centerY = geometry.size.height / 2.0
                
                path.move(to: CGPoint(x: 0, y: centerY))
                
                path.addLines([
                    CGPoint(x: 0, y: centerY),
                    CGPoint(x: geometry.size.width, y: centerY)
                ])
                
            }
            .stroke(self.color, lineWidth: 1)
            .opacity(0.5)
            
        }
        
    }
}
