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
    
    // Session QuestionPlayer Specific Properties
    @Published var currentQuestion: Question?
    @Published var currentQuestionId: UUID?
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
    
    // Lazy initialization of sessionAudioPlayer
    lazy var sessionAudioPlayer: SessionAudioPlayer = {
        return SessionAudioPlayer(context: self, audioFileSorter: audioFileSorter)
    }()
    
    var observers: [SessionObserver] = []
    var questionPlayer: QuestionPlayer
    var reviewer: ReviewsManager
    var sessionCloser: SessionCloser
    
    var audioFileSorter: AudioFileSorter
    var sessionInfo: QuizSessionInfoProtocol
    
    // UI Feedback and Status
    @Published var questionCounter: String = ""
    @Published var quizTitle: String = "VOQA"
    @Published var totalQuestionCount: Int = 0
    
    var questions: [Question] = []
    
    private var timer: Timer?
    
    init(state: QuizServices, questionPlayer: QuestionPlayer, reviewer: ReviewsManager, sessionCloser: SessionCloser, audioFileSorter: AudioFileSorter, sessionInfo: QuizSessionInfoProtocol) {
        self.state = state
        self.questionPlayer = questionPlayer
        self.reviewer = reviewer
        self.sessionCloser = sessionCloser
        self.audioFileSorter = audioFileSorter
        self.sessionInfo = sessionInfo
        
        self.questionPlayer.session = self
        self.reviewer.context = self
        self.sessionCloser.context = self
        
        // Initialize properties from sessionInfo
        self.quizTitle = sessionInfo.sessionTitle
        self.questions = sessionInfo.sessionQuestions
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
        
        return QuizSession(state: state, questionPlayer: questionPlayer, reviewer: reviewer, sessionCloser: sessionCloser, audioFileSorter: audioFileSorter, sessionInfo: sessionInfo)
    }
    
    func setState(_ state: QuizServices) {
        print("Setting state to \(type(of: state))")
        self.state = state
        self.state.handleState(session: self)
  
        notifyObservers()
    }
    
    func handleState(session: QuizSession) {
        // Placeholder for state handling logic
    }

    func startNewQuizSession(questions: [Question]) {
        print("Context Player Hit")
        self.questions = questions
        
        DispatchQueue.main.async {
            print("Ready to play \(self.questions.count) questions")
            self.updateQuestionCounter(questionIndex: self.questionPlayer.currentQuestionIndex, count: self.questions.count)
            self.activeQuiz = true
            self.startCountdown()
        }
    }
    
    private func playFirstQuestion() {
        DispatchQueue.main.async {
            self.questionPlayer.performAction(.setSessionQuestions, session: self)
        }
    }
    
    func beepAwaitingResponse() {
        self.setState(self)
        self.isAwaitingResponse = true
        self.sessionAudioPlayer.performAudioAction(.waitingForResponse)
    }
    
    private func beepRecievedResponse() {
        self.setState(self)
        self.currentQuestionText = "Checking..."
        self.isAwaitingResponse = false
        self.sessionAudioPlayer.performAudioAction(.receivedResponse)
    }
    
    func prepareToEndSession() {
        self.setState(self.sessionCloser)
        self.sessionCloser.performAction(.quitAndReset, session: self)
    }
    
    private func resumeQuiz() {
        self.setState(self.questionPlayer)
        self.questionPlayer.performAction(.readyToPlayNextQuestion, session: self)
    }
    
    func selectAnswer(selectedOption: String) {
        DispatchQueue.main.async {
            self.buttonSelected = selectedOption

            print("Selected Answer is \(self.buttonSelected)")
            print("Answer selected")
            self.currentQuestionText = "Checking Answer"
            self.beepRecievedResponse()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.sessionAudioPlayer.performAudioAction(.nextQuestion)
                self.resumeQuiz()
            }
        }
    }
    
    func pauseQuiz() {
       // self.questionPlayer.pausePlayback()
    }
    
    func updateQuestionCounter(questionIndex: Int, count: Int) {
        DispatchQueue.main.async {
            if self.activeQuiz {
                self.questionCounter = "Question \(questionIndex + 1) of \(count)"
            } else {
                self.questionCounter = "Ready to play \(self.questions.count) questions"
            }
        }
    }
    
    func updateCurrentQuestionId(_ questionId: UUID) {
        self.currentQuestionId = questionId
        print("Updated currentQuestionId to \(questionId)")
    }
    
    func updateQuizDetails() {
        DispatchQueue.main.async {
            self.quizTitle = ""
            self.totalQuestionCount = 0
        }
    }
    
    func stopCountdown() {
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
        // Observing Question Player Propeperties
        questionPlayer.$isPlayingQuestion
            .receive(on: DispatchQueue.main)
            .assign(to: &$isNowPlaying)
        
        questionPlayer.$hasMoreQuestions
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasAskedLastQuestion)
        
        questionPlayer.$currentQuestionId
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestionId)
        
        questionPlayer.$currentQuestion
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestion)
        
        
        print("current question ID: \(String(describing: currentQuestionId ?? nil))")
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
                self.playFirstQuestion()
            }
        }
    }
}















//import Foundation
//import Combine
//import AVFoundation
//
//class QuizSession: ObservableObject, QuizServices {
//    // Session General Utility Properties
//    @Published var state: QuizServices {
//        didSet {
//            notifyObservers()
//        }
//    }
//    
//    @Published var activeQuiz: Bool = false
//    @Published var countdownTime: TimeInterval = 5.0 // Default countdown time
//    @Published var responseTime: TimeInterval = 6.0 // Default response time
//    
//    // Session QuestionPlayer Specific Properties
//    @Published var currentQuestion: Question?
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
//    // Lazy initialization of sessionAudioPlayer
//    lazy var sessionAudioPlayer: SessionAudioPlayer = {
//        return SessionAudioPlayer(context: self)
//    }()
//    
//    var observers: [SessionObserver] = []
//    var questionPlayer: QuestionPlayer
//    var reviewer: ReviewsManager
//    var sessionCloser: SessionCloser
//    
//    // UI Feedback and Status
//    @Published var questionCounter: String = ""
//    @Published var quizTitleImage: String = ""
//    @Published var quizTitle: String = "VOQA"
//    @Published var totalQuestionCount: Int = 0
//    
//    var questions: [Question] = []
//    
//    private var timer: Timer?
//    
//    init(state: QuizServices, questionPlayer: QuestionPlayer, reviewer: ReviewsManager, sessionCloser: SessionCloser) {
//        self.state = state
//        self.questionPlayer = questionPlayer
//        self.reviewer = reviewer
//        self.sessionCloser = sessionCloser
//        
//        
//        self.questionPlayer.session = self
//        self.reviewer.context = self
//        self.sessionCloser.context = self
//        
//        setupObservers()
//    }
//    
//    static func create(state: QuizServices) -> QuizSession {
//        let questionPlayer = QuestionPlayer()
//        let reviewer = ReviewsManager()
//        let sessionCloser = SessionCloser()
//        let context = QuizSession(state: state, questionPlayer: questionPlayer, reviewer: reviewer, sessionCloser: sessionCloser)
//        
//        return context
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
//    func handleState(session: QuizSession) {
//        
//    }
//
//    func startNewQuizSession(questions: [Question]) {
//        print("Context Player Hit")
//        self.questions = questions
//        
//        DispatchQueue.main.async {
//            print("Ready to play \(self.questions.count) questions")
//            self.updateQuestionCounter(questionIndex: self.questionPlayer.currentQuestionIndex, count: self.questions.count)
//            self.activeQuiz = true
//            self.startCountdown()
//        }
//    }
//    
//    private func playFirstQuestion() {
//        DispatchQueue.main.async {
//            self.questionPlayer.performAction(.setSessionQuestions, session: self)
//        }
//    }
//    
//    func beepAwaitingResponse() {
//        self.setState(self)
//        self.isAwaitingResponse = true
//        self.sessionAudioPlayer.performAudioAction(.waitingForResponse)
//    }
//    
//    private func beepRecievedResponse() {
//        self.setState(self)
//        self.currentQuestionText = "Checking..."
//        self.isAwaitingResponse = false
//        self.sessionAudioPlayer.performAudioAction(.receivedResponse)
//    }
//    
//    func prepareToEndSession() {
//        self.setState(self.sessionCloser)
//        self.sessionCloser.performAction(.quitAndReset, session: self)
//    }
//    
//    private func resumeQuiz() {
//        self.setState(self.questionPlayer)
//        self.questionPlayer.performAction(.readyToPlayNextQuestion, session: self)
//    }
//    
//    func selectAnswer(selectedOption: String) {
//        DispatchQueue.main.async {
//            self.buttonSelected = selectedOption
//
//            print("Selected Answer is \(self.buttonSelected)")
//            print("Answer selected")
//            self.currentQuestionText = "Checking Answer"
//            self.beepRecievedResponse()
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//                self.sessionAudioPlayer.performAudioAction(.nextQuestion)
//                self.resumeQuiz()
//            }
//        }
//    }
//    
//    func pauseQuiz() {
//       // self.questionPlayer.pausePlayback()
//    }
//    
//    func updateQuestionCounter(questionIndex: Int, count: Int) {
//        DispatchQueue.main.async {
//            if self.activeQuiz {
//                self.questionCounter = "Question \(questionIndex + 1) of \(count)"
//            } else {
//                self.questionCounter = "Ready to play \(self.questions.count) questions"
//            }
//        }
//    }
//    
//    func updateCurrentQuestionId(_ questionId: UUID) {
//        self.currentQuestionId = questionId
//        print("Updated currentQuestionId to \(questionId)")
//    }
//    
//    func updateQuizDetails() {
//        DispatchQueue.main.async {
//            self.quizTitle = ""
//            self.quizTitleImage = ""
//            self.totalQuestionCount = 0
//        }
//    }
//    
//    func stopCountdown() {
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
//        //MARK: Observing Question Player Propeperties
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
//        
//        print("current question ID: \(String(describing: currentQuestionId ?? nil))")
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
//                self.playFirstQuestion()
//            }
//        }
//    }
//}
//
