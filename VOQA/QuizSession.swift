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
    @Published var currentQuestionIndex: Int = 0
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
    
    // UI Feedback and Status
    @Published var questionCounter: String = ""
    @Published var quizTitle: String = "VOQA"
    @Published var totalQuestionCount: Int = 0
    
    //Review Specific property
    @Published var isReviewing: Bool = false
    @Published var finalScore: Int = 0
    
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
    var scoreRegistry: ScoreRegistry
    
    var questions: [Question] = []
    private var countdownComplete: Bool = false
    
    private var timer: Timer?
    
    init(state: QuizServices, questionPlayer: QuestionPlayer, reviewer: ReviewsManager, sessionCloser: SessionCloser, audioFileSorter: AudioFileSorter, sessionInfo: QuizSessionInfoProtocol, scoreRegistry: ScoreRegistry) {
        self.state = state
        self.questionPlayer = questionPlayer
        self.reviewer = reviewer
        self.sessionCloser = sessionCloser
        self.audioFileSorter = audioFileSorter
        self.sessionInfo = sessionInfo
        self.scoreRegistry = scoreRegistry
        
        self.questionPlayer.session = self
        self.reviewer.session = self
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
        
        let scoreRegistry = ScoreRegistry()
        
        return QuizSession(state: state, questionPlayer: questionPlayer, reviewer: reviewer, sessionCloser: sessionCloser, audioFileSorter: audioFileSorter, sessionInfo: sessionInfo, scoreRegistry: scoreRegistry)
    }
    
    func setState(_ state: QuizServices) {
        print("Setting state to \(type(of: state))")
        self.state = state
        self.state.handleState(session: self)
  
        notifyObservers()
    }

    func startNewQuizSession(questions: [Question]) {
        print("Context Player Hit")
        self.questions = questions
        
        DispatchQueue.main.async {
            print("Ready to play \(self.questions.count) questions")
            self.updateQuestionCounter(questionIndex: 0, count: self.questions.count)
            self.activeQuiz = true
            self.startCountdown()
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
                countdownComplete = true
                self.playFirstQuestion()
            }
        }
    }
    
    func updateQuestionCounter(questionIndex: Int, count: Int) {
        DispatchQueue.main.async {
            if self.countdownComplete {
                self.questionCounter = "Question \(questionIndex + 1) of \(count)"
            } else {
                self.questionCounter = "Ready to play \(self.questions.count) questions"
            }
        }
    }
    
    private func playFirstQuestion() {
        DispatchQueue.main.async {
            self.questionPlayer.performAction(.setSessionQuestions, session: self)
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
    
    private func registerScore(question: Question, selectedOption: String) {
        scoreRegistry.checkAnswer(question: question, selectedOption: selectedOption) { isCorrect in
            if isCorrect {
                print("Correct Answer!")
                self.currentQuestionText = question.correctOption + " is Correct!"
                self.sessionAudioPlayer.performAudioAction(.playCorrectAnswerCallout)
            } else {
                print("Wrong Answer!")
                self.currentQuestionText = "Incorrect!\n\n" + question.overview
                self.sessionAudioPlayer.performAudioAction(.playWrongAnswerCallout)
                self.sessionAudioPlayer.performAudioAction(.playAnswer(url: question.overviewUrl))
            }
            
            // Update the finalScore
            self.finalScore = self.scoreRegistry.getCurrentScorePercentage(numberOfQuestions: self.questions.count)
        }
    }
    
    //TODO: Refactor Controls out of QuizSession
    func pauseQuiz() {
        self.sessionAudioPlayer.pausePlayer()
    }
    
    func stopQuiz() {
        self.sessionAudioPlayer.stopPlayback()
    }
    
    func nextQuestion() {
        self.questionPlayer.performAction(.readyToPlayNextQuestion, session: self)
        self.updateQuestionCounter(questionIndex: self.questionPlayer.currentQuestionIndex, count: self.totalQuestionCount)
    }
    
    func replayQuestion() {
        let questionPlayer = self.questionPlayer
        if let currentQuestion = self.currentQuestion {
            questionPlayer.performAction(.playCurrentQuestion(currentQuestion), session: self)
        }
    }
    
    
    private func recievedResponse() {
        self.setState(self)
        self.currentQuestionText = "Registering your score"
        self.isAwaitingResponse = false
        print("Awaiting response?: \(isAwaitingResponse)")
       // self.sessionAudioPlayer.performAudioAction(.receivedResponse)
    }
    
    func prepareToEndSession() {
        self.setState(self.sessionCloser)
        self.sessionCloser.performAction(.quitAndReset, session: self)
    }
    
    
    func resumeQuiz() {
        guard self.questionPlayer.hasMoreQuestions else {
            self.setState(self.reviewer)
            self.reviewer.performAction(.giveScore, session: self)
            return
        }
//        guard self.currentQuestionIndex <= self.questions.count - 1 else {
//            self.setState(self.reviewer)
//            self.reviewer.performAction(.reviewing, session: self)
//            return
//        }
        self.setState(self.questionPlayer)
        self.questionPlayer.performAction(.readyToPlayNextQuestion, session: self)
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
    
    func formatCurrentQuestionText() {
        if let currentQuestion = self.currentQuestion {
            let formattedText = QuestionFormatter.formatQuestionText(question: currentQuestion)
            DispatchQueue.main.async {
                self.currentQuestionText = formattedText
                print(formattedText)
            }
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
        
        questionPlayer.$currentQuestionIndex
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestionIndex)
        
        print("current question ID: \(String(describing: currentQuestionId ?? nil))")
    }
    
    func handleState(session: QuizSession) {}
      
}
