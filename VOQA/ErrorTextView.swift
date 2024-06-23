//
//  ErrorTextView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct ErrorTextView: View {
    let errorMessage: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ErrorTextView(errorMessage: "No internet connection")
}
