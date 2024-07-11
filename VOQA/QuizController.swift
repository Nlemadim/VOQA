//
//  QuizController.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/11/24.
//

import Foundation
import SwiftUI

class QuizController: QuizControlInterface {
    var session: QuizSession
    var sessionConfiguration: QuizSessionConfig
    
    init(sessionConfig: QuizSessionConfig) {
        self.sessionConfiguration = sessionConfig
        self.session = QuizController.initializeSession(with: sessionConfig)
    }
    
    var quizTitle: String { sessionConfiguration.sessionTitle }
    
    var quizImageUrl: String { return "" } // TODO: DESIGN SUITABLE IMAGE SOURCE
    
    var isActiveQuiz: Bool { session.activeQuiz }
    
    var isNowPlaying: Bool { session.isNowPlaying }
    
    var countdownTime: Double { session.countdownTime }
    
    var questionCount: Int { session.totalQuestionCount }
    
    var currentQuestionText: String { session.currentQuestionText }
    
    var isAwaitingResponse: Bool { session.isAwaitingResponse }
    
    func downloadQuiz() {
        // Implementation for downloading quiz
    }
    
    func startQuiz() {
        session.startNewQuizSession(questions: getQuestions())
    }
    
    func getQuestions() -> [Question] {
        // Fetch questions here
        return []
    }
    
    func pauseQuiz() {
        session.pauseQuiz()
    }
    
    func stopQuiz() {
        session.stopQuiz()
    }
    
    func repeatQuestion() {
        session.replayQuestion()
    }
    
    func skipQuestion() {
        session.nextQuestion()
    }
    
    private static func initializeSession(with config: QuizSessionConfig) -> QuizSession {
        print("QuizController initialized Session")
        
        let sessionInitializer = SessionInitializer(config: config)
        let sessionInfo = sessionInitializer.initializeSession()
        let audioFileSorter = AudioFileSorter(randomGenerator: SystemRandomNumberGenerator())
        audioFileSorter.configure(with: config)

        return QuizSession(
            state: IdleSession(), // Assuming IdleSession is a valid state
            questionPlayer: QuestionPlayer(),
            reviewer: ReviewsManager(),
            sessionCloser: SessionCloser(),
            audioFileSorter: audioFileSorter,
            sessionInfo: sessionInfo
        )
    }
    
    private func fetchConfigQuestions() async -> [Question] {
        // Implementation for fetching questions asynchronously
        return []
    }
}
