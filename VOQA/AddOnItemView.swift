//
//  AddOnItemView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/28/24.
//

import Foundation
import SwiftUI

struct AddOnItemView: View {
    @Binding var item: AddOnItem
    @State private var isDownloading: Bool = false
    var download: () -> Void
    var sample: () -> Void
    var select: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            itemImageView
            
            VStack(alignment: .leading, spacing: 10) {
                itemDetails
                
                Spacer()
                
                actionButtons
            }
            .frame(height: 200)
        }
        .padding(.horizontal)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(Material.ultraThin)
                .frame(height: 230)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
                .frame(height: 230)
        )
    }
    
    private var itemImageView: some View {
        Image(item.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 200)
            .cornerRadius(10)
            .overlay {
                VStack {
                    Spacer()
                    Button(action: {
                        select()
                    }) {
                        Text(item.isSelected ? "Selected" : "Select")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .background(item.isSelected ? Color.green : Color.white.opacity(0.5))
                            .foregroundColor(item.isSelected ? .white : .black)
                            .cornerRadius(5)
                    }
                }
            }
    }
    
    private var itemDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(item.about)
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 5) {
            SmallDownloadButton(label: "Download", color: Color.teal.opacity(0.5), iconImage: "arrow.down.circle") {
                isDownloading = true
                download()
            }
            SmallDownloadButton(label: "Sample", color: Color.white.opacity(0.5), iconImage: "speaker.fill", action: {
                sample()
            })
        }
    }
}
