//
//  QuizSessionManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import Foundation
import Combine

class QuizSessionManager: ObservableObject {
    @Published var quizSession: QuizSession?
    private var cancellables: Set<AnyCancellable> = []

    init() {}

    func initializeSession(with config: QuizSessionConfig) {
        print("QuizSessionManager initialized")
        let sessionInitializer = SessionInitializer(config: config)
        let sessionInfo = sessionInitializer.initializeSession()
        let scoreRegistry = ScoreRegistry()
        let audioFileSorter = AudioFileSorter(randomGenerator: SystemRandomNumberGenerator())
        audioFileSorter.configure(with: config)

        self.quizSession = QuizSession(
            state: IdleSession(), // Assuming IdleSession is a valid state
            questionPlayer: QuestionPlayer(),
            reviewer: ReviewsManager(),
            sessionCloser: SessionCloser(),
            audioFileSorter: audioFileSorter,
            sessionInfo: sessionInfo, scoreRegistry: scoreRegistry
        )

        // Bind properties from QuizSession to trigger updates
        quizSession?.$currentQuestionText
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        quizSession?.$questionCounter
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        quizSession?.$isNowPlaying
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        quizSession?.$isAwaitingResponse
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // Expose necessary methods
    func nextQuestion() {
        guard let quizSession = quizSession else { return }
        quizSession.questionPlayer.performAction(.readyToPlayNextQuestion, session: quizSession)
        updateQuestionCounter()
    }

    private func updateQuestionCounter() {
        guard let quizSession = quizSession else { return }
        let questionIndex = quizSession.questionPlayer.currentQuestionIndex
        let totalCount = quizSession.questions.count
        quizSession.updateQuestionCounter(questionIndex: questionIndex, count: totalCount)
    }

    func selectAnswer(selectedOption: String) {
        quizSession?.selectAnswer(selectedOption: selectedOption)
    }

    func startNewQuizSession(questions: [Question]) {
        quizSession?.startNewQuizSession(questions: questions)
    }
}

