
//
//  DownloadButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/18/24.
//

import Foundation
import SwiftUI

struct DownloadButton: View {
    @State private var isDownloading: Bool = false
    var label: String
    var action: () async -> Void
    
    var body: some View {
        Button(action: {
            isDownloading = true
            Task {
                await action()
                isDownloading = false
            }
        }) {
            if isDownloading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 20, height: 20)
            } else {
                Text(label)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(.teal.opacity(0.6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .disabled(isDownloading)
    }
}
