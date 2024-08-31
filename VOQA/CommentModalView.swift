//
//  CommentModalView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/31/24.
//

import Foundation
import SwiftUI

struct CommentModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var comment: String // Binding to the comment text
    @FocusState private var isTextEditorFocused: Bool // Focus state for the text editor

    var body: some View {
        VStack(alignment: .leading) {
            // Text editor for typing a comment
            TextEditor(text: $comment)
                .focused($isTextEditorFocused)
                .frame(minHeight: 50)
                .frame(height: 200)
                .cornerRadius(8)
                .lineSpacing(5)
                .font(.system(size: 16, weight: .regular, design: .default))
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .overlay {
                    if comment.isEmpty {
                        Text("Type your comment here...")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                }
                .onAppear {
                    isTextEditorFocused = true // Set focus to the text editor when the view appears
                }
            
            // Submit button
            Button(action: {
                isTextEditorFocused = true
                dismiss()
                print("Submit comment tapped with comment: \(comment)")
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(comment.isEmpty ? Color.gray.opacity(0.4) : Color.teal.opacity(0.7))
                    .cornerRadius(10)
            }
            .disabled(comment.isEmpty)
            
            Spacer()
        }
        .padding()
        .background(.ultraThickMaterial.opacity(0.5))
    }
}
