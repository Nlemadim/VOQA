//
//  QuizViewModel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation
import SwiftUI
import Combine


protocol QuizViewModelProtocol {
    var seesionId: UUID { get }
    var sessionTitle: String { get }
    var sessionVoice: String { get }
    var currentQuestionText: String { get }
    var questionCounter: String { get }
    func nextQuestion()
    func selectAnswer(selectedOption: String)
    func stopQuiz()
    func repeatQuestion()
    func quitQuiz()
}

class QuizViewModel: ObservableObject, QuizViewModelProtocol {
    @Published var sessionConfiguration: QuizSessionConfig?
    @Published var currentQuestionText: String = ""
    @Published var sessionQuestionCounterText: String = ""
    @Published var questionCounter: String = ""
    @Published var sessionNowplayingAudio: Bool = false
    @Published var sessionAwaitingResponse: Bool = false
    @Published var seesionId: UUID = UUID()
    @Published var sessionTitle: String = ""
    @Published var sessionVoice: String = ""
    @Published var sessionCountdownTime: TimeInterval = 5.0
    @Published var sessionTimer: TimeInterval = 5.0
    @Published var currentQuestionIndex: Int = 0
    @Published var sessionInReview: Bool = false
    @Published var currentQuestion: (any QuestionType)? = nil
    
    private var sfxPlayer = SfxPlayer()
    var quizSessionManager: QuizSessionManager
    private var quizConfigManager: QuizConfigManager
    private var cancellables: Set<AnyCancellable> = []

    init(quizSessionManager: QuizSessionManager, quizConfigManager: QuizConfigManager) {
        self.quizSessionManager = quizSessionManager
        self.quizConfigManager = quizConfigManager
        
        // Bind properties from quizSessionManager to the ViewModel
        quizSessionManager.$quizSession
            .compactMap { $0 }
            .sink { [weak self] session in
                guard let self = self else { return }
                self.bindSession(session)
            }
            .store(in: &cancellables)
    }

    private func bindSession(_ session: QuizSession) {
        session.$currentQuestionText
            .assign(to: &$currentQuestionText)
        
        session.$questionCounter
            .assign(to: &$questionCounter)
        
        session.$isNowPlaying
            .assign(to: &$sessionNowplayingAudio)
        
        session.$isAwaitingResponse
            .assign(to: &$sessionAwaitingResponse)
        
        session.$questionCounter
            .assign(to: &$sessionQuestionCounterText)
        
        session.$countdownTime
            .assign(to: &$sessionCountdownTime)
        
        session.$quizTimer
            .assign(to: &$sessionTimer)
        
        session.$isReviewing
            .assign(to: &$sessionInReview)
        
        session.$currentQuestionIndex
            .assign(to: &$currentQuestionIndex)
        
        // Bind the current question from the session
        session.$currentQuestion
            .assign(to: &$currentQuestion) // Now the view model tracks the current question
    }
    
    func currentQuizSession() -> QuizSession? {
        guard let session = quizSessionManager.quizSession else { return nil }
        return session
    }
    
    func startNewQuizSession(questions: [Question]) {
        quizSessionManager.startNewQuizSession(questions: questions)
    }


    func nextQuestion() {
        quizSessionManager.nextQuestion()
        sfxPlayer.play(.nextQuestion)
    }

    func selectAnswer(selectedOption: String) {
        quizSessionManager.selectAnswer(selectedOption: selectedOption)
        sfxPlayer.play(.hasReceivedResponse)
    }

    
    func stopQuiz() {
        quizSessionManager.stopQuiz()
    }

    func repeatQuestion() {
        // Implement repeat logic
    }

    func quitQuiz() {
        // Implement quit logic
    }

    func initializeSession(with config: QuizSessionConfig) {
        print("Quiz Player viewModel has initialized a session")
        seesionId = config.sessionId
        sessionTitle = config.sessionTitle
        sessionVoice = config.sessionVoice
        quizSessionManager.initializeSession(with: config)
    }
    
    func playNextQuestionSfx() {
        sfxPlayer.play(.nextQuestion)
    }
    
    func playAwaitingResponseSfx() {
        sfxPlayer.play(.awaitResponse)
    }
    
    func playRecievedResponseSfx() {
        sfxPlayer.play(.hasReceivedResponse)
    }
    
    func playbackVisualizer() -> any View {
        guard let session = quizSessionManager.quizSession  else { return EmptyView() }
        return  VUMeterView(quizContext: session)
    }
    
    var countdownTimerText: String {
        let time = Int(sessionCountdownTime)
        return "\(time)"
    }
    
    func initializeVoqaExperience(questions: [Question]) {
        //sfxPlayer.playIntroMusic()
    }

}

