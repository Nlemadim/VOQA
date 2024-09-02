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
    let completedQuizzes: Int
    let mainColor: Color
    let subColor: Color
    @State var performanceHistory: [Performance]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                HStack(spacing: 4) {
                    Text("High Score")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(subColor)
                            .font(.subheadline)
                            
                        Text("\(Int(highScore))%")
                            .font(.body)
                            .fontWeight(.black)
                    }
                }
                
                Spacer()
                //MARK: To Be Implemented in V2
//                HStack {
//                    
//                    Text("Rank:")
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                    
//                    Text(rank.uppercased())
//                        .font(.body)
//                        .fontWeight(.black)
//                        .foregroundColor(.yellow)
//                }
            }
            
            HStack {
                Text("\(completedQuizzes)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Quizzes Completed")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Divider()
                
            PerformanceHistoryGraph(history: $performanceHistory, mainColor: mainColor, subColor: subColor)
                
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
    PerformanceView(highScore: 80, completedQuizzes: 789, mainColor: .green, subColor: .purple,  performanceHistory: mockHistory)
        .preferredColorScheme(.dark)
}

let mockHistory: [Performance] = [
    
    Performance(id: UUID(), date: Date(), score: 40, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 80, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 30, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 90, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 30, numberOfQuestions: 20),
    Performance(id: UUID(), date: Date(), score: 20, numberOfQuestions: 10),
    Performance(id: UUID(), date: Date(), score: 70, numberOfQuestions: 10)

]


