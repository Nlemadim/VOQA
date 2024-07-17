//
//  ScoreRegistry.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/17/24.
//

import Foundation
import SwiftUI

class ScoreRegistry: ObservableObject {
    @StateObject private var databaseManager = DatabaseManager.shared
    @Published var currentScore: CGFloat = 0.0
    @Published var currentScoreStreak: Int = 0
    
    //initialize with

    func checkAnswer(question: Question, selectedOption: String, isCorrect: @escaping (Bool) -> Void) {
        
        if selectedOption == question.correctOption {
            currentScore += 1
            currentScoreStreak += 1
            isCorrect(true)
        } else {
            currentScoreStreak = 0
            isCorrect(false)
        }
    }
    
    func createPerformanceRecord(title: String, numberOfQuestions: Int) {
        let performance = Performance(id: UUID(), quizTitle: title, date: Date(), score: currentScore, numberOfQuestions: numberOfQuestions)
        //update databaseManager and pass on to the environment
    }
    
    func getPerformanceReview() -> String {
        //Network call to get performanceReview audioUrl
        return ""
    }
    
}
