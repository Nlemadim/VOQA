//
//  SmallDownloadButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/28/24.
//

import Foundation
import SwiftUI

struct SmallDownloadButton: View {
    var label: String
    var color: Color
    var iconImage: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
           action()
        }) {
            HStack {
                Text(label)
                Image(systemName: iconImage)
            }
            .font(.footnote)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .background(color)
            .cornerRadius(5)
        }
    }
}


struct MediumDownloadButton: View {
    var label: String
    var color: Color
    var iconImage: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
           action()
        }) {
            HStack {
                Text(label)
                Image(systemName: iconImage)
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(color.dynamicTextColor())
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(color)
            .cornerRadius(10)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 1.0)
                .opacity(color == .clear ? 1 : 0)
        }
    }
}
