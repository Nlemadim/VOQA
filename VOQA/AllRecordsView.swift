//
//  AllRecordsView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/20/24.
//

import Foundation
import SwiftUI

struct AllRecordsView: View {
    var quizzesCompleted = 26
    var totalAnsweredQuestions = 230
    var highScore: CGFloat
    var numberOfTestsTaken: Int
    
    var body: some View {
        HStack {
            
            Text("All Time Records")
                .foregroundStyle(.primary)
                .fontWeight(.bold)
                .kerning(-0.5) // Reduces the default spacing between characters
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .hAlign(.leading)
        
        VStack(spacing: 15) {
            
            scoreLabel(
                withTitle: "Quizzes Completed",
                iconName: "doc.questionmark",
                score: "\(numberOfTestsTaken)"
            )
            
            scoreLabel(
                withTitle: "High Score",
                iconName: "trophy",
                score: "\(highScore)%"
            )
            
            scoreLabel(
                withTitle: "Total Number of Questions",
                iconName: "questionmark.circle",
                score: "∞"
            )
            
            scoreLabel(
                withTitle: "Questions Answered",
                iconName: "checkmark.circle",
                score: "\(totalAnsweredQuestions)"
            )
            
            scoreLabel(
                withTitle: "Questions Skipped",
                iconName: "forward.frame.fill",
                score: "\(0)"
            )
        }
        .padding(.horizontal)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }

    
    private func scoreLabel(withTitle title: String, iconName: String, score: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(.teal)
               
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(score)
                .font(.subheadline)
        }
    }
}




                                                        
                                                        
