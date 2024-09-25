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
    var orchestra: QuizOrchestra
    
    // var questions: [Question] = [] // Removed as it's now managed by QuestionPlayer
    private var countdownComplete: Bool = false
    
    private var timer: Timer?
    private var quizStartTimer: Timer?
    var bgmPlayer: BgmPlayer
    
    init(state: QuizServices, questionPlayer: QuestionPlayer, reviewer: ReviewsManager, sessionCloser: SessionCloser, audioFileSorter: AudioFileSorter, sessionInfo: QuizSessionInfoProtocol, scoreRegistry: ScoreRegistry, commandCenter: CommandCenter, orchestra: QuizOrchestra, bgmPlayer: BgmPlayer) {
        self.state = state
        self.questionPlayer = questionPlayer
        self.reviewer = reviewer
        self.sessionCloser = sessionCloser
        self.audioFileSorter = audioFileSorter
        self.sessionInfo = sessionInfo
        self.scoreRegistry = scoreRegistry
        self.commandCenter = commandCenter
        self.orchestra = orchestra
        self.bgmPlayer = bgmPlayer  // Assign bgmPlayer
        
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
        let orchestra = QuizOrchestra(commandCenter: commandCenter)

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
            orchestra: orchestra,
            bgmPlayer: bgmPlayer  // Pass bgmPlayer to QuizSession
        )

        // Now that the QuizSession is created, set it in the CommandCenter
        commandCenter.session = quizSession

        return quizSession
    }


    
    func setState(_ state: QuizServices) {
        print("Setting state to \(type(of: state))")
        self.state = state
        self.state.handleState(session: self)
  
        notifyObservers()
    }
    
    func startQuiz() {
        print("Session: Starting quiz.")
        //MARK: TODO put a guard cj=heck to make sure there are questions before start
        orchestra.startFlow()
        self.isNowPlaying = true
    }

    func startNewQuizSession(questions: [any QuestionType]) {
        print("Context Player Hit")
        
        // Start the quiz
        DispatchQueue.main.async {
            print("Ready to play \(questions.count) questions")
            self.questionPlayer.setSessionQuestions(questions)
            self.activeQuiz = true
            self.startCountdown()
            
            // Start the quiz timer
            self.startQuizTimer()
        }
    }
    
    private func startCountdown() {
        print("Starting countdown")
        timer?.invalidate()
        var remainingTime = countdownTime
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if remainingTime > 0 {
                remainingTime -= 1
                self.countdownTime = remainingTime
            } else {
                timer.invalidate()
                self.countdownComplete = true // Added 'self.' for clarity
                self.playFirstQuestion()
            }
        }
    }
    
    // Method to start the quiz timer
    private func startQuizTimer() {
        quizTimer = 0.0
        quizStartTimer?.invalidate()
        quizStartTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.quizTimer += 1.0
        }
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
    
    private func playFirstQuestion() {
        DispatchQueue.main.async {
            self.questionPlayer.playCurrentQuestion() // Changed to use protocol method
        }
    }
    
    func awaitResponse() {
        self.setState(self)
        self.isAwaitingResponse = true
        print("Awaiting response?: \(isAwaitingResponse)")
    }
    
    func selectAnswer(selectedOption: String) {
        guard let currentQuestion = currentQuestion else { return }
        
        DispatchQueue.main.async {
            self.buttonSelected = selectedOption
            self.isAwaitingResponse = false
            self.currentQuestionText = "Checking Answer"
            
            self.registerScore(question: currentQuestion, selectedOption: selectedOption)
        }
    }
    
    private func registerScore(question: any QuestionType, selectedOption: String) { // Changed parameter type
        // Implement score registration logic here.
        // Ensure that 'QuestionType' has necessary properties or methods.
        // Example:
        // if let specificQuestion = question as? Question { ... }
    }
    
    private func recievedResponse() {
        self.setState(self)
        self.currentQuestionText = "Registering your score"
        self.isAwaitingResponse = false
        print("Awaiting response?: \(isAwaitingResponse)")
       // self.sessionAudioPlayer.performAudioAction(.receivedResponse)
    }
    
    func resumeQuiz() {
        guard self.questionPlayer.hasMoreQuestions else {
            self.setState(self.reviewer)
            self.reviewer.performAction(.giveScore, session: self)
            return
        }

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



//class QuizSession: ObservableObject, QuizServices {
//    // Session General Utility Properties
//    @Published var state: QuizServices {
//        didSet {
//            notifyObservers()
//        }
//    }
//    
//    @Published var activeQuiz: Bool = false
//    @Published var countdownTime: TimeInterval = 5.0
//    @Published var responseTime: TimeInterval = 6.0
//    
//    // Session QuestionPlayer Specific Properties
//    @Published var currentQuestion: (any QuestionType)? // Changed from 'Question?' to 'any QuestionType?'
//    // @Published var currentQuestionv2: QuestionV2? // Removed as redundant
//    @Published var currentQuestionIndex: Int = 0
//    @Published var currentQuestionId: UUID?
//    @Published var currentQuestionText: String = ""
//    @Published var hasAskedLastQuestion: Bool = false
//    @Published var isLastQuestion: Bool = false
//    
//    // Session Awaiting Response And Validation Specific Properties
//    @Published var isAwaitingResponse: Bool = false
//    @Published var spokenAnswerOption: String = ""
//    @Published var buttonSelected: String = ""
//    @Published var hasResponded: Bool = false
//    @Published var isReadyForNextQuestion: Bool = false
//    
//    // Session Audio Specific Properties
//    @Published var isNowPlaying: Bool = false
//    
//    // UI Feedback and Status
//    @Published var questionCounter: String = ""
//    @Published var quizTitle: String = "VOQA"
//    @Published var totalQuestionCount: Int = 0
//    
//    // Review Specific property
//    @Published var isReviewing: Bool = false
//    @Published var finalScore: Int = 0
//    
//    // Lazy initialization of sessionAudioPlayer
//    lazy var sessionAudioPlayer: SessionAudioPlayer = {
//        return SessionAudioPlayer(context: self, audioFileSorter: audioFileSorter)
//    }()
//    
//    var observers: [SessionObserver] = [] // Changed from 'private var observers' to 'var observers'
//    var questionPlayer: QuestionPlayer
//    var reviewer: ReviewsManager
//    var sessionCloser: SessionCloser
//    var audioFileSorter: AudioFileSorter
//    var sessionInfo: QuizSessionInfoProtocol
//    var scoreRegistry: ScoreRegistry
//    
//    // var questions: [Question] = [] // Removed as it's now managed by QuestionPlayer
//    private var countdownComplete: Bool = false
//    
//    private var timer: Timer?
//    
//    init(state: QuizServices, questionPlayer: QuestionPlayer, reviewer: ReviewsManager, sessionCloser: SessionCloser, audioFileSorter: AudioFileSorter, sessionInfo: QuizSessionInfoProtocol, scoreRegistry: ScoreRegistry) {
//        self.state = state
//        self.questionPlayer = questionPlayer
//        self.reviewer = reviewer
//        self.sessionCloser = sessionCloser
//        self.audioFileSorter = audioFileSorter
//        self.sessionInfo = sessionInfo
//        self.scoreRegistry = scoreRegistry
//        
//        self.questionPlayer.session = self
//        self.reviewer.session = self
//        self.sessionCloser.context = self
//        
//        // Initialize properties from sessionInfo
//        self.quizTitle = sessionInfo.sessionTitle
//        // self.questions = sessionInfo.sessionQuestions // Removed
//        self.totalQuestionCount = sessionInfo.sessionQuestions.count
//        setupObservers()
//    }
//    
//    static func create(state: QuizServices, config: QuizSessionConfig) -> QuizSession {
//        let questionPlayer = QuestionPlayer()
//        let reviewer = ReviewsManager()
//        let sessionCloser = SessionCloser()
//        let sessionInitializer = SessionInitializer(config: config)
//        
//        let sessionInfo = sessionInitializer.initializeSession()
//        let audioFileSorter = AudioFileSorter(randomGenerator: SystemRandomNumberGenerator())
//        audioFileSorter.configure(with: config)
//        
//        let scoreRegistry = ScoreRegistry()
//        
//        return QuizSession(state: state, questionPlayer: questionPlayer, reviewer: reviewer, sessionCloser: sessionCloser, audioFileSorter: audioFileSorter, sessionInfo: sessionInfo, scoreRegistry: scoreRegistry)
//    }
//    
//    func setState(_ state: QuizServices) {
//        print("Setting state to \(type(of: state))")
//        self.state = state
//        self.state.handleState(session: self)
//  
//        notifyObservers()
//    }
//
//    func startNewQuizSession(questions: [any QuestionType]) { // Changed parameter type from [Question] to [any QuestionType]
//        print("Context Player Hit")
//        // self.questions = questions // Removed as QuestionPlayer manages questions
//        
//        DispatchQueue.main.async {
//            print("Ready to play \(questions.count) questions")
//            // self.updateQuestionCounter(questionIndex: 0, count: self.questions.count) // Removed
//            self.questionPlayer.setSessionQuestions(questions) // Delegate setting questions to QuestionPlayer
//            self.activeQuiz = true
//            self.startCountdown()
//        }
//    }
//    
//    private func startCountdown() {
//        print("Starting countdown")
//        timer?.invalidate()
//        var remainingTime = countdownTime
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
//            guard let self = self else { return }
//            if remainingTime > 0 {
//                remainingTime -= 1
//                self.countdownTime = remainingTime
//            } else {
//                timer.invalidate()
//                self.countdownComplete = true // Added 'self.' for clarity
//                self.playFirstQuestion()
//            }
//        }
//    }
//    
//    func updateQuestionCounter(questionIndex: Int, count: Int) {
//        DispatchQueue.main.async {
//            if self.countdownComplete {
//                self.questionCounter = "Question \(questionIndex + 1) of \(count)"
//            } else {
//                self.questionCounter = "Ready to play \(count) questions" // Changed to use 'count' parameter
//            }
//        }
//    }
//    
//    private func playFirstQuestion() {
//        DispatchQueue.main.async {
//            self.questionPlayer.playCurrentQuestion() // Changed to use protocol method
//        }
//    }
//    
//    func awaitResponse() {
//        self.setState(self)
//        self.isAwaitingResponse = true
//        print("Awaiting response?: \(isAwaitingResponse)")
//    }
//    
//    func selectAnswer(selectedOption: String) {
//        guard let currentQuestion = currentQuestion else { return }
//        
//        DispatchQueue.main.async {
//            self.buttonSelected = selectedOption
//            self.isAwaitingResponse = false
//            self.currentQuestionText = "Checking Answer"
//            
//            self.registerScore(question: currentQuestion, selectedOption: selectedOption)
//        }
//    }
//    
//    private func registerScore(question: any QuestionType, selectedOption: String) { // Changed parameter type to 'any QuestionType'
//        // Implement score registration logic here.
//        // Ensure that 'QuestionType' has necessary properties or methods.
//        // Example:
//        // if let specificQuestion = question as? Question { ... }
//    }
//    
//    private func recievedResponse() {
//        self.setState(self)
//        self.currentQuestionText = "Registering your score"
//        self.isAwaitingResponse = false
//        print("Awaiting response?: \(isAwaitingResponse)")
//       // self.sessionAudioPlayer.performAudioAction(.receivedResponse)
//    }
//    
//    func prepareToEndSession() {
//        self.setState(self.sessionCloser)
//        self.sessionCloser.performAction(.quitAndReset, session: self)
//    }
//    
//    func resumeQuiz() {
//        guard self.questionPlayer.hasMoreQuestions else {
//            self.setState(self.reviewer)
//            self.reviewer.performAction(.giveScore, session: self)
//            return
//        }
//
//        self.setState(self.questionPlayer)
//        self.questionPlayer.prepareNextQuestion()
//    }
//    
//    func sessionReset() {
//        self.activeQuiz = false
//        self.countdownTime = 5.0
//        self.currentQuestion = nil
//        self.currentQuestionText = "Ended"
//        self.questionCounter = "_:_"
//        self.totalQuestionCount = 0
//        self.finalScore = 0
//        self.scoreRegistry.currentScore = 0
//        // self.questions = [] // Removed
//        self.questionPlayer.resetQuestionIndex() // Use the protocol method instead of direct assignment
//        // self.questionPlayer.questions = [] // Removed
//    }
//
//    
//    func updateCurrentQuestionId(_ questionId: UUID) {
//        self.currentQuestionId = questionId
//        print("Updated currentQuestionId to \(questionId)")
//    }
//    
//    
//    private func stopCountdown() {
//        timer?.invalidate()
//    }
//
//    func addObserver(_ observer: SessionObserver) {
//        observers.append(observer)
//    }
//    
//    func notifyObservers() {
//        for observer in observers {
//            observer.stateDidChange(to: state)
//        }
//    }
//
//    private func setupObservers() {
//        // Updated Observing Question Player Properties
//        
//        questionPlayer.$isPlayingQuestion
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$isNowPlaying)
//        
//        questionPlayer.$hasMoreQuestions
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$hasAskedLastQuestion)
//        
//        questionPlayer.$currentQuestionId
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$currentQuestionId)
//        
//        questionPlayer.$currentQuestion
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$currentQuestion)
//        
//        questionPlayer.$currentQuestionIndex
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$currentQuestionIndex)
//        
//        print("current question ID: \(String(describing: currentQuestionId ?? nil))")
//    }
//    
//    func handleState(session: QuizSession) {}
//    
//    //TODO: Refactor Controls out of QuizSession
//    func pauseQuiz() {
//        self.sessionAudioPlayer.pausePlayer()
//    }
//    
//    func stopQuiz() {
//        self.sessionAudioPlayer.stopPlayback()
//    }
//    
//    func nextQuestion() {
//        self.questionPlayer.prepareNextQuestion() // Changed to use protocol method
//        self.updateQuestionCounter(questionIndex: self.questionPlayer.currentQuestionIndex, count: self.totalQuestionCount)
//    }
//    
//    func replayQuestion() {
//        questionPlayer.replayQuestion() // Changed to use protocol method
//    }
//}
