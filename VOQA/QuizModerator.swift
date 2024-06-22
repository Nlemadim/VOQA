//
//  QuizModerator.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//
import Foundation
import SwiftUI


class QuizModerator {
    var context: QuizContext
    var responseTime: TimeInterval = 5.0 // Default response time

    init(context: QuizContext) {
        self.context = context
    }

    func startQuiz() {
        context.activeQuiz = true
        context.setState(StartedQuizState())
        // Other initialization logic for starting a quiz
    }

    func validateResponse(_ response: String, for questionId: UUID) {
        guard let question = context.audioPlayer?.questions.first(where: { $0.id == questionId }) else {
            print("Question not found")
            return
        }
        
        guard !response.isEmptyOrWhiteSpace else {
            context.setState(FeedbackMessageState(type: .noResponse))
            return
        }

        if response.lowercased() == question.correctOption.lowercased() {
            print("Correct answer!")
            // Trigger feedback state with correct answer feedback
            context.setState(FeedbackMessageState(type: .correctAnswer))
        } else {
            print("Incorrect answer.")
            // Trigger feedback state with incorrect answer feedback
            context.setState(FeedbackMessageState(type: .incorrectAnswer))
        }
    }

    func endQuiz() {
        context.activeQuiz = false
        context.setState(EndedQuizState())
        // Other cleanup logic for ending a quiz
    }

    func setResponseTime(_ time: TimeInterval) {
        responseTime = time
    }
}
