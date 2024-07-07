//
//  QuizSessionManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import Foundation
import SwiftUI
import Combine

class QuizSessionManager: ObservableObject {
    @Published private var quizSession: QuizSession

    init(state: QuizServices) {
        self.quizSession = QuizSession.create(state: state)
    }
    
    // Expose necessary properties
    var currentQuestionText: String {
        return quizSession.currentQuestionText
    }
    
    var questionCounter: String {
        return quizSession.questionCounter
    }
    
    // Expose necessary methods
    func nextQuestion() {
        quizSession.questionPlayer.performAction(.readyToPlayNextQuestion, session: quizSession)
        updateQuestionCounter()
    }
    
    private func updateQuestionCounter() {
        let questionIndex = quizSession.questionPlayer.currentQuestionIndex
        let totalCount = quizSession.questions.count
        quizSession.updateQuestionCounter(questionIndex: questionIndex, count: totalCount)
    }
    
    func selectAnswer(selectedOption: String) {
        quizSession.selectAnswer(selectedOption: selectedOption)
    }
    
    func startNewQuizSession(questions: [Question]) {
        quizSession.startNewQuizSession(questions: questions)
    }
    
    func registerScore(for question: Question, withAnswer answer: String) {
        // Implement score registration logic here
    }
}
