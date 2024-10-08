//
//  CategoryRow.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/17/24.
//

import Foundation
import SwiftUI

struct QuizSelection: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String?
    let isLocked: Bool
    let iconName: String // New property for the icon
}

// MARK: - CategoryRow View
struct QuizSelectionRow: View {
    let category: QuizSelection
    let isLoadingQuiz: Bool?
    let action: () -> Void
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Category Icon
            Image(systemName: category.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(category.isLocked ? .gray : (category.iconName == "dot.scope" ? .orange : .teal))
                .accessibilityLabel(Text("Target Topic: \(category.name) Icon"))
            
            // Category Text
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: false)
                    .fixedSize(horizontal: false, vertical: true)
                
                if category.isLocked {
                    Text(category.subtitle ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
            
            // Lock, Play Button, or Spinner
            if isLoadingQuiz ?? false {
               ProgressView()
                    .frame(width: 30, height: 30)
            } else {
                Button(action: {
                    action()
                }) {
                    if category.isLocked {
                        Image(systemName: "lock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                // Disable button if a quiz is already loading
                .disabled(isLoadingQuiz ?? false)
            }
        }
        .padding()
        .background(category.isLocked ? Color.gray.opacity(0.1) : Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
