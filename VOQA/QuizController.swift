//
//  QuizController.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/11/24.
//

import Foundation
import SwiftUI

class QuizController: ObservableObject, QuizControlInterface {
    @Published var sessionTitle: String = ""
    @Published var questionText: String = "" {
        didSet {
            self.questionText = session.currentQuestionText
        }
    }
    @Published var isPlayingAudio: Bool = false {
        didSet {
            if session.isNowPlaying {
                self.isPlayingAudio = true
            }
        }
    }
    @Published var sessionActive: Bool = false{
        didSet {
            if session.activeQuiz {
                self.sessionActive = true
            }
        }
    }
    
    @Published var awaitingResponse: Bool = false {
        didSet {
            if session.isAwaitingResponse {
                self.awaitingResponse = true
            }
        }
    }
    
    var session: QuizSession
    var sessionConfiguration: QuizSessionConfig
    
    init(sessionConfig: QuizSessionConfig) {
        self.sessionConfiguration = sessionConfig
        self.session = QuizController.initializeSession(with: sessionConfig)
    }
    
    var quizTitle: String {
        sessionConfiguration.sessionTitle
    }
    
    func getTitle(){
        self.sessionTitle = sessionConfiguration.sessionTitle
    }
    
    
    
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
    
    func startQuiz(questions: [Question]) {
        session.startNewQuizSession(questions: questions)
    }
    
    func getQuestions() -> [Question] {
        let questions = DatabaseManager.shared.questions
        // Fetch questions here
        return questions
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
    
    static func initializeSession(with config: QuizSessionConfig) -> QuizSession {
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
    
    func printQuestionDetails(question: Question) {
        print("Question Content: \(question.content)")
        print("Question Script: \(question.audioScript)")
        print("Audio URL: \(question.audioUrl)")
        print("Overview URL: \(question.overviewUrl)")
    }
}
