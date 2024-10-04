//
//  ScoreRegistry.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/17/24.
//

import Foundation
import SwiftUI

class ScoreRegistry: ObservableObject {
    @EnvironmentObject private var databaseManager: DatabaseManager
    @Published var currentScore: CGFloat = 0.0
    @Published var currentScoreStreak: Int = 0
    @Published var currentScorePercentage: Int = 0
    
    // Check the answer and update the score
    func checkAnswer(question: Question, selectedOption: String, isCorrect: @escaping (Bool) -> Void) {
//        if selectedOption == question.correctOption {
//            currentScore += 1
//            currentScoreStreak += 1
//            isCorrect(true)
//        } else {
//            currentScoreStreak = 0
//            isCorrect(false)
//        }
    }
    
    // Create a performance record
    func createPerformanceRecord(title: String, numberOfQuestions: Int) {
//        let performance = Performance(id: UUID(), quizTitle: title, date: Date(), score: currentScore, numberOfQuestions: numberOfQuestions)
//        print(performance.quizTitle)
        // update databaseManager and pass on to the environment
    }
    
    // Calculate the current score percentage and round up to the nearest 10
    func getCurrentScorePercentage(numberOfQuestions: Int) -> Int {
        guard numberOfQuestions > 0 else { return 0 }
        let percentage = (currentScore / CGFloat(numberOfQuestions)) * 100
        let roundedPercentage = ceil(percentage / 10) * 10
        return Int(roundedPercentage)
    }
    
    // Get performance review (network call to get performanceReview audioUrl)
    func getPerformanceReview() -> String {
        return ""
    }
}

