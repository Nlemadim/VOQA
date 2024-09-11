//
//  AddToLibraryButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/7/24.
//

import SwiftUI

struct AddToLibraryButton: View {
    var color: Color
    var label: String
    var image: String?
    @State var isDisabled: Bool?
    var playAction: () -> Void

    var body: some View {
        Button(action: {
            self.isDisabled?.toggle()
            playAction()
        }) {
            
            if let image {
                HStack {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    
                    Text(label)
                        .font(.subheadline)
                        .foregroundStyle(color.dynamicTextColor())
                        
                }
            } else {
                Text(label)
                    .font(.subheadline)
            }
            
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(color)
        .foregroundColor(.white)
        .activeGlow(.white, radius: 1)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
        )
        .disabled(isDisabled ?? false)
    }
}


#Preview {
    AddToLibraryButton(color: .red, label: "", playAction: {})
}
