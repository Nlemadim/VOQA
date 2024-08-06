//
//  PerformanceView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/20/24.
//

import Foundation
import SwiftUI
import Combine

struct PerformanceView: View {
    @StateObject private var viewModel = PerformanceTrackerViewModel(performances: [
        Performance(id: UUID(), quizTitle: "Quiz 1", date: Date(), score: 45.7, numberOfQuestions: 10),
        Performance(id: UUID(), quizTitle: "Quiz 2", date: Date(), score: 6.8, numberOfQuestions: 10),
        Performance(id: UUID(), quizTitle: "Quiz 2", date: Date(), score: 70.0, numberOfQuestions: 15),
        Performance(id: UUID(), quizTitle: "Quiz 2", date: Date(), score: 15.5, numberOfQuestions: 10),
        Performance(id: UUID(), quizTitle: "Quiz 2", date: Date(), score: 29.7, numberOfQuestions: 10),
        Performance(id: UUID(), quizTitle: "Quiz 2", date: Date(), score: 40.0, numberOfQuestions: 15)
        
    ])
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 8.0) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    PerformanceTrackerBar(viewModel: viewModel)
                        .padding(.top)
                    
                    PerformanceHistoryGraph(history: viewModel.performances, mainColor: .teal, subColor: .white)
                        .padding(.bottom)
                    
                    AllRecordsView(quizzesCompleted: viewModel.performances.count, totalAnsweredQuestions: 20, highScore: 80, numberOfTestsTaken: 2)
                        .padding(.bottom)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        .frame(height: 100)
                        
                }
                .background {
                    HomePageBackground()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 2){
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("My Stats")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .kerning(-0.5)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}
