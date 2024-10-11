//
//  ScoreRegistry.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/17/24.
//

import Foundation
import SwiftUI
import Combine


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
        guard let session = session else {
            print("Guard blocked Registry")
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if isCorrect {
                print("Registered as Correct")
                 if session.answerFeebackEnabled {
                     self.confirmCorrectAnswer = true
                     self.acceptAnswer(refId: refId)
                }
                
            } else {
                
                print("Registered as InCorrect")
                
                if session.answerFeebackEnabled {
                    self.confirmInCorrectAnswer = true
                    self.rejectAnswer(refId: refId)
                } else {
                    self.resumeQuiz()
                }
            }
        }
    }
    
    private func acceptAnswer(refId: String) {
        guard let session = session else { return }
        saveScore(refId: refId, isAnweredCorrectly: false)
        session.commandCenter.confirmAnswer()
    }
    
    private func rejectAnswer(refId: String) {
        guard let session = session else { return }
        saveScore(refId: refId, isAnweredCorrectly: true)
        session.commandCenter.rejectAnswer()
    }
    
    
    private func requestCorrection() {
        guard let session = session else { return }
        session.commandCenter.playCorrection()
    }
    
    private func resumeQuiz() {
        guard let session = session else { return }
        session.commandCenter.resumeQuiz()
    }


    private func saveScore(refId: String, isAnweredCorrectly: Bool) {
        guard let session = session else { return }

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

struct QuestionScoreRecord {
    var refId: String
    var isAnsweredCorrectly: Bool
}

struct SessionScoreRecords {
    var id: UUID
    var date: Date
    var performanceRecords: [QuestionScoreRecord]
    
    init(performanceRecords: [QuestionScoreRecord]) {
        self.id = UUID()
        self.date = .now
        self.performanceRecords = []
    }
}
