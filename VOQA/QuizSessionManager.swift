//
//  QuizSessionManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
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
        
        // Initialize BgmPlayer with sessionMusic from the config
        let bgmPlayer = BgmPlayer(audioUrls: config.sessionMusic.map { $0.audioUrl })  // Use the sessionMusic array from config
        
        // Initialize CommandCenter without session reference yet
        let commandCenter = CommandCenter(session: nil)
        let quizOrchestra = QuizOrchestra(commandCenter: commandCenter)
        
        // Create QuizSession with the CommandCenter, Orchestra, and BgmPlayer
        let quizSession = QuizSession(
            state: IdleSession(),
            questionPlayer: QuestionPlayer(),
            reviewer: ReviewsManager(),
            sessionCloser: SessionCloser(),
            audioFileSorter: audioFileSorter,
            sessionInfo: sessionInfo,
            scoreRegistry: scoreRegistry,
            commandCenter: commandCenter,
            orchestra: quizOrchestra,
            bgmPlayer: bgmPlayer  
        )
        
        // Now that the QuizSession is created, set it in the CommandCenter
        commandCenter.session = quizSession
        bgmPlayer.delegate = quizOrchestra
        
        // Assign the created session to the Published quizSession property
        self.quizSession = quizSession
        
        // Bind properties from QuizSession to trigger updates in the view model
        quizSession.$currentQuestionText
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        quizSession.$questionCounter
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        quizSession.$isNowPlaying
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        quizSession.$isAwaitingResponse
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }



    // Expose necessary methods
    func nextQuestion() {
        guard let quizSession = quizSession else { return }
        quizSession.questionPlayer.performAction(.prepareNextQuestion, session: quizSession)
        updateQuestionCounter()
    }

    private func updateQuestionCounter() {
//        guard let quizSession = quizSession else { return }
//        let questionIndex = quizSession.questionPlayer.currentQuestionIndex
//        let totalCount = quizSession.questionPlayer.currentQuestions.count
//        quizSession.updateQuestionCounter(questionIndex: questionIndex, count: totalCount)
    }
    
    func startNewQuiz() {
        quizSession?.startQuiz()
    }

    func selectAnswer(selectedOption: String) {
        quizSession?.selectAnswer(selectedOption: selectedOption)
    }

    func startNewQuizSession(questions: [Question]) {
        quizSession?.startNewQuizSession(questions: questions)
    }
    
    func stopQuiz() {
        quizSession?.stopQuiz()
    }
}


