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
    @Published var questionCounter: String = ""
    @Published var seesionId: UUID = UUID()
    @Published var sessionTitle: String = ""
    @Published var sessionVoice: String = ""
    @Published var sessionQuestions: [Question] = []

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
                self.currentQuestionText = session.currentQuestionText
                self.questionCounter = session.questionCounter
            }
            .store(in: &cancellables)
    }

    func nextQuestion() {
        quizSessionManager.nextQuestion()
    }

    func selectAnswer(selectedOption: String) {
        quizSessionManager.selectAnswer(selectedOption: selectedOption)
    }

    func startNewQuizSession() {
        quizSessionManager.startNewQuizSession(questions: sessionQuestions)
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

    func downloadQuestions() async {
        do {
            let questions = try await quizConfigManager.downloadQuestions()
            DispatchQueue.main.async {
                self.sessionQuestions = questions
                self.quizSessionManager.startNewQuizSession(questions: questions)
            }
        } catch {
            print("Failed to download questions: \(error)")
        }
    }

    func initializeSession(with config: QuizSessionConfig) {
        seesionId = config.sessionId
        sessionTitle = config.sessionTitle
        sessionVoice = config.sessionVoice
        sessionQuestions = config.sessionQuestion

        quizSessionManager.initializeSession(with: config)
    }
}
