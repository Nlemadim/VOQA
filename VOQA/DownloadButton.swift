
//
//  DownloadButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/18/24.
//

import SwiftUI

import SwiftUI

struct DownloadButton: View {
    @Binding var isDownloading: Bool
    var label: String
    var action: () async -> Void
    var cancelAction: (() -> Void)? = nil

    var body: some View {
        VStack {
            Button(action: {
                Task {
                    isDownloading = true
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
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.teal, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .disabled(isDownloading)

            // Cancel Button
            Button(action: {
                if isDownloading {
                    isDownloading = false
                    cancelAction?()
                }
            }) {
                Text(isDownloading ? "Cancel" : "Back")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}
