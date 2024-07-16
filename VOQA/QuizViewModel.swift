//
//  QuizViewModel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation
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
    }

    func nextQuestion() {
        quizSessionManager.nextQuestion()
    }

    func selectAnswer(selectedOption: String) {
        quizSessionManager.selectAnswer(selectedOption: selectedOption)
    }

    func startNewQuizSession(questions: [Question]) {
        quizSessionManager.startNewQuizSession(questions: questions)
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
    
}

