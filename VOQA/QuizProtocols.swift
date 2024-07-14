//
//  QuizProtocols.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation

/// Protocol representing a state in the quiz.
protocol QuizServices {
    var observers: [SessionObserver] { get set }
    
    /// Handles the logic associated with this state.
    func handleState(session: QuizSession)
    
    /// Adds an observer to the state.
    func addObserver(_ observer: SessionObserver)
    
    /// Notifies all observers about the state change.
    func notifyObservers()
}

protocol SessionObserver: AnyObject {
    func stateDidChange(to newState: QuizServices)
}


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

// Session Controller Protocol
protocol QuizControlInterface {
    var quizTitle: String { get }
    var quizImageUrl: String { get }
    var isActiveQuiz: Bool { get }
    var isNowPlaying: Bool { get }
    var countdownTime: Double { get }
    var questionCount: Int { get }
    var currentQuestionText: String { get }
    var isAwaitingResponse: Bool { get }
    func downloadQuiz()
    func startQuiz(questions: [Question])
    func pauseQuiz()
    func stopQuiz()
    func repeatQuestion()
    func skipQuestion()
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
