//
//  QuizSessionManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import Foundation
import SwiftUI
import Combine

import SwiftUI
import Combine

class QuizSessionManager: ObservableObject {
    @Published var quizSession: QuizSession
    private var cancellables: Set<AnyCancellable> = []

    init(state: QuizServices) {
        self.quizSession = QuizSession.create(state: state)
        observeQuestionPlayerAction()
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
    
    private func observeQuestionPlayerAction() {
//        quizSession.$questionPlayer.action
//            .sink { [weak self] action in
//                guard let self = self else { return }
//                if action == .readyForNextQuestion {
//                    self.nextQuestion()
//                }
//            }
//            .store(in: &cancellables)
    }
}
