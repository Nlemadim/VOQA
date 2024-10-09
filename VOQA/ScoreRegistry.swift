//
//  ScoreRegistry.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/17/24.
//

import Foundation
import SwiftUI


class ScoreRegistry: ObservableObject {
    @ObservedObject private var databaseManager = DatabaseManager.shared
    @ObservedObject private var user = User()
    
    @Published var currentScore: CGFloat = 0.0
    @Published var currentScoreStreak: Int = 0
    @Published var currentScorePercentage: Int = 0

    @Published var playCorrection: Bool = false
    @Published var confirmCorrectAnswer: Bool = false
    @Published var confirmInCorrectAnswer: Bool = false
    @Published var readyToResumed: Bool = false
    
    var session: QuizSession?
    // Check the answer and update the score
    func checkAnswer(isCorrect: Bool, refId: String) {
        guard let session = session else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if isCorrect {
                 if session.answerFeebackEnabled {
                    self.confirmCorrectAnswer = true
                }
                
            } else {
                
                if session.answerFeebackEnabled {
                    self.confirmInCorrectAnswer = true
                }
                
                if session.isQandASession {
                    session.answerFeebackEnabled = true
                    self.playCorrection = true
                }
                
                self.readyToResumed = true
            }
        }
    }

    private func saveScore(refId: String) {
        
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

