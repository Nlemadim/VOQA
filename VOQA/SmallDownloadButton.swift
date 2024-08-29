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
