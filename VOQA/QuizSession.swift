//
//  QuizSession.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation
import Combine
import AVFoundation

class QuizSession: ObservableObject, QuizServices {
    // Session General Utility Properties
    @Published var state: QuizServices {
        didSet {
            notifyObservers()
        }
    }
    
    @Published var activeQuiz: Bool = false
    @Published var countdownTime: TimeInterval = 5.0
    @Published var responseTime: TimeInterval = 6.0
    @Published var quizTimer: TimeInterval = 0.0
    @Published var isQandASession: Bool = false
    @Published var answerFeebackEnabled: Bool = false
    
    // Session QuestionPlayer Specific Properties
    @Published var currentQuestion: (any QuestionType)? // Changed from 'Question?' to 'any QuestionType?'
    // @Published var currentQuestionv2: QuestionV2? // Removed as redundant
    @Published var currentQuestionIndex: Int = 0
    @Published var currentQuestionId: String? // Changed from UUID? to String?
    @Published var currentQuestionText: String = ""
    @Published var hasAskedLastQuestion: Bool = false
    @Published var isLastQuestion: Bool = false
    
    
    // Session Awaiting Response And Validation Specific Properties
    @Published var isAwaitingResponse: Bool = false
    @Published var spokenAnswerOption: String = ""
    @Published var buttonSelected: String = ""
    @Published var hasResponded: Bool = false
    @Published var isReadyForNextQuestion: Bool = false
    
    // Session Audio Specific Properties
    @Published var isNowPlaying: Bool = false
    
    // UI Feedback and Status
    @Published var questionCounter: String = ""
    @Published var quizTitle: String = "VOQA"
    @Published var totalQuestionCount: Int = 0
    
    // Review Specific property
    @Published var isReviewing: Bool = false
    @Published var finalScore: Int = 0
    
    // Lazy initialization of sessionAudioPlayer
    lazy var sessionAudioPlayer: SessionAudioPlayer = {
        return SessionAudioPlayer(context: self, audioFileSorter: audioFileSorter)
    }()
    
    
    var observers: [SessionObserver] = [] // Changed from 'private var observers' to 'var observers'
    var questionPlayer: QuestionPlayer
    var reviewer: ReviewsManager
    var sessionCloser: SessionCloser
    var audioFileSorter: AudioFileSorter
    var sessionInfo: QuizSessionInfoProtocol
    var scoreRegistry: ScoreRegistry
    var commandCenter: CommandCenter
    var conductor: Conductor
    
    // var questions: [Question] = [] // Removed as it's now managed by QuestionPlayer
    private var countdownComplete: Bool = false
    
    private var timer: Timer?
    var quizStartTimer: Timer?
    var bgmPlayer: BgmPlayer
    var dynamicContentManager: DynamicContentManager
    
    init(state: QuizServices, questionPlayer: QuestionPlayer, reviewer: ReviewsManager, sessionCloser: SessionCloser, audioFileSorter: AudioFileSorter, sessionInfo: QuizSessionInfoProtocol, scoreRegistry: ScoreRegistry, commandCenter: CommandCenter, conductor: Conductor, bgmPlayer: BgmPlayer, dynamicContentmanager: DynamicContentManager) {
        self.state = state
        self.questionPlayer = questionPlayer
        self.reviewer = reviewer
        self.sessionCloser = sessionCloser
        self.audioFileSorter = audioFileSorter
        self.sessionInfo = sessionInfo
        self.scoreRegistry = scoreRegistry
        self.commandCenter = commandCenter
        self.conductor = conductor
        self.bgmPlayer = bgmPlayer
        self.dynamicContentManager = dynamicContentmanager
        
        // Initialize properties from sessionInfo
        self.quizTitle = sessionInfo.sessionTitle
        self.totalQuestionCount = sessionInfo.sessionQuestions.count
        
        
        setupObservers()
    }
    
    
    static func create(state: QuizServices, config: QuizSessionConfig) -> QuizSession {
        let questionPlayer = QuestionPlayer()
        let reviewer = ReviewsManager()
        let sessionCloser = SessionCloser()
        let sessionInitializer = SessionInitializer(config: config)
        
        let sessionInfo = sessionInitializer.initializeSession()
        let audioFileSorter = AudioFileSorter(randomGenerator: SystemRandomNumberGenerator())
        audioFileSorter.configure(with: config)
        
        let scoreRegistry = ScoreRegistry()
        
        // Create BgmPlayer first
        let bgmPlayer = BgmPlayer(audioUrls: config.sessionMusic.map { $0.audioUrl })  // Passing sessionMusic to BgmPlayer
        
        // Initialize CommandCenter and QuizOrchestra without session reference yet
        let commandCenter = CommandCenter(session: nil)  // Temporarily set session as nil
        let conductor = Conductor(commandCenter: commandCenter)
        let dynamicContentManager = DynamicContentManager()
        dynamicContentManager.configure(with: config)
        
        // Create the QuizSession
        let quizSession = QuizSession(
            state: state,
            questionPlayer: questionPlayer,
            reviewer: reviewer,
            sessionCloser: sessionCloser,
            audioFileSorter: audioFileSorter,
            sessionInfo: sessionInfo,
            scoreRegistry: scoreRegistry,
            commandCenter: commandCenter,
            conductor: conductor,
            bgmPlayer: bgmPlayer,
            dynamicContentmanager: dynamicContentManager  // Pass bgmPlayer to QuizSession
        )
        
        // Now that the QuizSession is created, set it in the CommandCenter
        commandCenter.session = quizSession
        dynamicContentManager.session = quizSession
        conductor.session = quizSession
        bgmPlayer.delegate = conductor
        quizSession.sessionAudioPlayer.sessionAudioDelegate = conductor
        
        return quizSession
    }
    
    func setState(_ state: QuizServices) {
        print("Setting state to \(type(of: state))")
        self.state = state
        self.state.handleState(session: self)
        
        notifyObservers()
    }
    
    func fetchSessionIntro() -> [String] {
        
        return []
    }
    
    func startQuiz() {
        print("Session: Starting quiz.")
        self.setState(conductor)
        conductor.startFlow()
        self.isNowPlaying = true
    }
    
    // Stop the timer when the quiz session ends
    func prepareToEndSession() {
        self.setState(self.sessionCloser)
        self.sessionCloser.performAction(.quitAndReset, session: self)
        
        // Stop the quiz timer
        stopQuizTimer()
    }
    
    // Method to stop the quiz timer
    private func stopQuizTimer() {
        quizStartTimer?.invalidate()
        quizStartTimer = nil
    }
    
    func updateQuestionCounter(questionIndex: Int, count: Int) {
        DispatchQueue.main.async {
            if self.countdownComplete {
                self.questionCounter = "Question \(questionIndex + 1) of \(count)"
            } else {
                self.questionCounter = "Ready to play \(count) questions" // Changed to use 'count' parameter
            }
        }
    }
    
    func awaitResponse() {
        self.setState(self)
        self.isAwaitingResponse = true
    }
    
    func selectAnswer(selectedOption: String) {
        guard let currentQuestion = self.questionPlayer.currentQuestion else {
            print("No current question available.")
            return
        }
        
        self.setState(self)
        
        DispatchQueue.main.async {
            // Attempt to cast to the concrete Question type
            if var concreteQuestion = currentQuestion as? Question {
                print("Recieving Question Response")
                // Use the selectOption method to determine correctness
                let isCorrect = concreteQuestion.selectOption(selectedOption: selectedOption)
                let refId = concreteQuestion.refId
                
                //Update UI state
                self.buttonSelected = selectedOption
                self.recieveResponse()
                
                // Register the score based on correctness
                self.registerScore(isCorrect: isCorrect, refId: refId)
            } else {
                print("Failed to cast currentQuestion to Question.")
                // Handle the error as needed, possibly by notifying the user or logging
            }
        }
    }
    
    
    private func recieveResponse() {
        self.setState(self)
        self.currentQuestionText = "Registering your score"
        //self.isAwaitingResponse = false
        self.hasResponded = true
    }
    
    
    private func registerScore(isCorrect: Bool, refId: String) {
        self.scoreRegistry.checkAnswer(isCorrect: isCorrect, refId: refId)
    }
    
    
    
    
    func resumeQuiz() {
        guard self.questionPlayer.hasMoreQuestions else {
            self.setState(self.reviewer)
            self.reviewer.performAction(.giveScore, session: self)
            return
        }
        
        self.hasResponded = false
        self.isAwaitingResponse = false
        self.setState(self.questionPlayer)
        self.questionPlayer.prepareNextQuestion() // Changed to use protocol method
    }
    
    func sessionReset() {
        self.activeQuiz = false
        self.countdownTime = 5.0
        self.currentQuestion = nil
        self.currentQuestionText = "Ended"
        self.questionCounter = "_:_"
        self.totalQuestionCount = 0
        self.finalScore = 0
        self.scoreRegistry.currentScore = 0
        self.questionPlayer.resetQuestionIndex()
        
        self.quizTimer = 0.0
    }
    
    func updateCurrentQuestionId(_ questionId: String) { // Changed parameter type
        self.currentQuestionId = questionId
        print("Updated currentQuestionId to \(questionId)")
    }
    
    
    private func stopCountdown() {
        timer?.invalidate()
    }
    
    func addObserver(_ observer: SessionObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: state)
        }
    }
    
    private func setupObservers() {
        // Updated Observing Question Player Properties
        
        questionPlayer.$isPlayingQuestion
            .receive(on: DispatchQueue.main)
            .assign(to: &$isNowPlaying)
        
        questionPlayer.$hasMoreQuestions
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasAskedLastQuestion)
        
        questionPlayer.$currentQuestionId
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestionId) // Now String? matches
        
        questionPlayer.$currentQuestion
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestion) // (any QuestionType)?
        
        questionPlayer.$currentQuestionIndex
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestionIndex)
        
        print("current question ID: \(String(describing: currentQuestionId ?? nil))")
    }
    
    
    func handleState(session: QuizSession) {}
    
    //TODO: Refactor Controls out of QuizSession
    func pauseQuiz() {
        self.sessionAudioPlayer.pausePlayer()
    }
    
    func stopQuiz() {
        self.sessionAudioPlayer.stopPlayback()
    }
    
    func nextQuestion() {
        self.questionPlayer.prepareNextQuestion() // Changed to use protocol method
        self.updateQuestionCounter(questionIndex: self.questionPlayer.currentQuestionIndex, count: self.totalQuestionCount)
    }
    
    func replayQuestion() {
        questionPlayer.replayQuestion() // Changed to use protocol method
    }
}

