//
//  PerformanceView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/20/24.
//

import Foundation
import SwiftUI

struct PerformanceView: View {
    let highScore: CGFloat
    let leaderboardScore: Int
    let leaderboardMembers: Int
    let completedQuizzes: Int 
    let rank: String
    let performances: [Performance]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                HStack(spacing: 4) {
                    Text("High Score")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                            
                        Text("\(Int(highScore))%")
                            .font(.body)
                            .fontWeight(.black)
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    Text("Rank:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text(rank.uppercased())
                        .font(.body)
                        .fontWeight(.black)
                        .foregroundColor(.yellow)
                }
            }
            
            HStack {
                Text("\(completedQuizzes)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("Quizzes Completed")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Divider()
                
                PerformanceHistoryGraph(history: [
                    Performance(id: UUID(), date: Date(), score: 40, numberOfQuestions: 10),
                    Performance(id: UUID(), date: Date(), score: 80, numberOfQuestions: 10),
                    Performance(id: UUID(), date: Date(), score: 30, numberOfQuestions: 10),
                    Performance(id: UUID(), date: Date(), score: 90, numberOfQuestions: 10),
                    Performance(id: UUID(), date: Date(), score: 30, numberOfQuestions: 20),
                    Performance(id: UUID(), date: Date(), score: 20, numberOfQuestions: 10),
                    Performance(id: UUID(), date: Date(), score: 70, numberOfQuestions: 10)
                ], mainColor: .white, subColor: .yellow)
                
                Divider()
                    .padding(.top)
                
                NavigationLink(destination: Text("Performance History")) {
                    PageLinkView(title: "Performance History")
                        .font(.footnote)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Divider()
                    .padding(.top)
     
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 20)
        .padding(.horizontal, 10)
        
    }
}


struct PerformanceCellView: View {
    let performance: Performance
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(performance.quizCategory ?? "Unknown Category")
                    .font(.headline)
                
                Text("\(performance.numberOfQuestions) Questions")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(performance.score))%")
                .font(.title3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}


#Preview {
    PerformanceView(highScore: 80, leaderboardScore: 235, leaderboardMembers: 789, completedQuizzes: 56, rank: "Silver", performances: mockHistory)
        .preferredColorScheme(.dark)
}

let mockHistory = [
    
    Performance(id: UUID(), date: Date(), score: 40, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 80, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 30, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 90, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 30, numberOfQuestions: 20),
    Performance(id: UUID(), date: Date(), score: 20, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 70, numberOfQuestions: 10)

]
