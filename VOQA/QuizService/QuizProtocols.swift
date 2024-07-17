//
//  QuizProtocols.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation

// Protocols for QuizSession
protocol QuizSessionInfoProtocol {
    var sessionTitle: String { get }
    var sessionQuestions: [Question] { get }
}

// Session Initializer Protocol
protocol SessionInitializerProtocol {
    func initializeSession() -> QuizSessionInfoProtocol
    func initializeAudioFileSorter() -> QuizSessionConfig
}

protocol QuizViewModelProtocol {
    var seesionId: UUID { get }
    var sessionTitle: String { get }
    var sessionVoice: String { get }
    var sessionQuestions: [Question] { get }
    var currentQuestionText: String { get }
    var questionCounter: String { get }
    
    func nextQuestion()
    func selectAnswer(selectedOption: String)
    func startNewQuizSession()
    func stopQuiz()
    func repeatQuestion()
    func quitQuiz()
    func downloadQuestions() async
}
