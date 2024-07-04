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
    //Session General Utility Property
    @Published var state: QuizServices {
        didSet {
            notifyObservers()
        }
    }
    
    @Published var activeQuiz: Bool = false
    @Published var countdownTime: TimeInterval = 5.0 // Default countdown time
    @Published var responseTime: TimeInterval = 6.0 // Default response time
    
    //Session QuestionPlayer Specific Properties
    @Published var currentQuestion: Question?
    @Published var currentQuestionId: UUID?
    @Published var currentQuestionText: String = ""
    @Published var hasMoreQuestions: Bool = false
    @Published var isLastQuestion: Bool = false
    
    //Session Awaiting Response And Validation Specific Properties
    @Published var isAwaitingResponse: Bool = false
    @Published var spokenAnswerOption: String = ""
    @Published var buttonSelected: String = ""
    @Published var hasResponded: Bool = false
    
    //Session Audio Specific Properties
    @Published var isNowPlaying: Bool = false
    
    
    lazy var sessionAudioPlayer: SessionAudioPlayer = {
        return SessionAudioPlayer(context: self)
    }()

    var observers: [SessionObserver] = []
    var questionPlayer: QuestionPlayer
    var responsePresenter: ResponsePresenter
    var responseValidator: ResponseValidationManager
    var reviewer: ReviewsManager
    var sessionCoordinator: SessionCoordinator
    var sessionCloser: SessionCloser
    
    //UI Feedback and Status
    @Published var questionCounter: String = ""
    @Published var quizTitleImage: String = ""
    @Published var quizTitle: String = "VOQA"
    @Published var totalQuestionCount: Int = 0
    
    var questions: [Question] = []
    
    private var timer: Timer?
    
    init(state: QuizServices, questionPlayer: QuestionPlayer, responsePresenter: ResponsePresenter, responseValidator: ResponseValidationManager, reviewer: ReviewsManager, sessionCoOrdinator: SessionCoordinator, sessionCloser: SessionCloser) {
        
        self.state = state
        self.questionPlayer = questionPlayer
        self.responsePresenter = responsePresenter
        self.responseValidator = responseValidator
        self.reviewer = reviewer
        self.sessionCoordinator = sessionCoOrdinator
        self.sessionCloser = sessionCloser
        self.questionPlayer.session = self
        self.responseValidator.session = self
        self.reviewer.context = self
        self.sessionCoordinator.session = self
        self.sessionCloser.context = self
        setupObservers()
    }
    
    static func create(state: QuizServices) -> QuizSession {
        let questionPlayer = QuestionPlayer()
        let responsePresenter = ResponsePresenter()
        let responseValidator = ResponseValidationManager()
        let reviewer = ReviewsManager()
        let presenter = SessionCoordinator()
        let sessionCloser = SessionCloser()
        let context = QuizSession(state: state, questionPlayer: questionPlayer, responsePresenter: responsePresenter, responseValidator: responseValidator, reviewer: reviewer, sessionCoOrdinator: presenter, sessionCloser: sessionCloser)
        
        return context
    }
    
    func setState(_ state: QuizServices) {
        print("Setting state to \(type(of: state))")
        self.state = state
        self.state.handleState(context: self)
  
        notifyObservers()
    }
    
    func handleState(context: QuizSession) {
        
    }

    func startQuiz() {
        print("Context Player Hit")
        guard !self.questions.isEmpty else {
            print("Questions unavailable")
            return
        }
        
        DispatchQueue.main.async {
            print("Ready to play \(self.questions.count) questions")
            self.updateQuestionCounter(questionIndex: self.questionPlayer.currentQuestionIndex, count: self.questions.count)
            self.activeQuiz = true
            self.startCountdown()
        }
    }
    
    private func playFirstQuestion() {
        DispatchQueue.main.async {
            self.questionPlayer.performAction(.loadNewSessionQuestions, session: self)
        }
    }
    
    func selectAnswer(selectedOption: String) {
        self.buttonSelected = selectedOption
        self.responsePresenter.performAction(.dismissResponsePresentation, session: self)
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
            self.quizTitleImage = ""
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
        //MARK: Observing Question Player Propeperties
        questionPlayer.$isPlayingQuestion
            .receive(on: DispatchQueue.main)
            .assign(to: &$isNowPlaying)
        
        questionPlayer.$hasMoreQuestions
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasMoreQuestions)
        
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

