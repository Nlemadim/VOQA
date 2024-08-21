//
//  AcceptButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

struct AcceptButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isEnabled ? Color.black : .white)
                .padding()
                .background(isEnabled ? Color.white : .clear)
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
        .frame(height: 44)
        .padding(.vertical)
        .padding()
    }
}

