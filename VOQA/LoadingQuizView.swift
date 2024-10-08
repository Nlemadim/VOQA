//
//  LoadingQuizView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/17/24.
//

import Foundation
import SwiftUI

// MARK: - LoadingQuizView
struct LoadingQuizView: View {
    var category: QuizSelection
    let onCancel: () -> Void
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            
            Text("Loading \(category.name) Questions...")
                .font(.headline)
                .foregroundStyle(.primary.opacity(0.8))
                .padding(.horizontal)
                .padding(.top, 100)
                .hAlign(.leading)
                .opacity(isLoading ? 1 : 0)
            
            QuizSelectionRow(category: category, isLoadingQuiz: true) {
                
            }
            .allowsHitTesting(false) // Disable interactions with the row while loading
            
            // Cancel Button
            Button(action: {
                onCancel()
                self.isLoading = false
                 //should we not invalidate category here
            }) {
                HStack {
                    Image(systemName: "x.circle")
                    Text("Cancel")
                }
                .foregroundColor(.red)
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .onAppear {
            startLoading()
        }
        .alert(isPresented: .constant(false)) {
            // Placeholder for potential future alerts
            Alert(title: Text("Loading"))
        }
    }
    
    func startLoading() {
        // Simulate a loading process (e.g., network request)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = true
            // Handle completion, such as navigating to the quiz view
            // For example:
            // navigateToQuiz()
        }
    }
}

