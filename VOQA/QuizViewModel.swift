//
//  QuizViewModel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation
import SwiftUI
import Combine

class QuizViewModel: ObservableObject, QuizViewModelProtocol {

    @Published var currentQuestionText: String = ""
    @Published var sessionQuestionCounterText: String = ""
    @Published var questionCounter: String = ""
    @Published var sessionNowplayingAudio: Bool = false
    @Published var sessionAwaitingResponse: Bool = false
    @Published var seesionId: UUID = UUID()
    @Published var sessionTitle: String = ""
    @Published var sessionVoice: String = ""
    @Published var sessionCountdownTime: TimeInterval = 5.0
    @Published var currentQuestionIndex: Int = 0
    @Published var sessionInReview: Bool = false
    
    private var sfxPlayer = SfxPlayer()
    private var quizSessionManager: QuizSessionManager
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
        
        session.$isReviewing
            .assign(to: &$sessionInReview)
        
        session.$currentQuestionIndex
            .assign(to: &$currentQuestionIndex)
            
    }
    
    func currentSession() -> QuizSession? {
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
        // Implement stop logic
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
    
    
}

