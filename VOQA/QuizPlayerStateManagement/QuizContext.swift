//
//  QuizContext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation
import Combine
import AVFoundation

class QuizContext: ObservableObject,  QuizState {
    lazy var quizContextPlayer: QuizContextPlayer = {
        return QuizContextPlayer(context: self)
    }()
    
    @Published var state: QuizState {
        didSet {
            notifyObservers()
        }
    }

    var observers: [StateObserver] = []
    var questionPlayer: QuestionPlayer
    var quizModerator: QuizModerator
    var reviewer: ReviewState
    var listener: ListeningState
    var feedbackMessenger: FeedbackMessageState
    var presenter: QuizPresenter
    //var feedbackMessagState: FeedbackMessageState
    
    @Published var activeQuiz: Bool = false
    @Published var countdownTime: TimeInterval = 5.0 // Default countdown time
    @Published var responseTime: TimeInterval = 6.0 // Default response time
    @Published var isListening: Bool = false
    @Published var questionCounter: String = ""
    @Published var isDownloading: Bool = false
    @Published var hasMoreQuestions: Bool = false
    @Published var isLastQuestion: Bool = false
    @Published var quizTitleImage: String = ""
    @Published var quizTitle: String = "VOQA"
    @Published var totalQuestionCount: Int = 0
    @Published var currentQuestionText: String = ""
    @Published var hasQuestions: Bool = false
    @Published var isPlaying: Bool = false
    @Published var buttonSelected: String = ""
    @Published var currentQuestionId: UUID?
    @Published var currentQuestion: Question?
    @Published var spokenAnswerOption: String = ""
    
    var questions: [Question] = []
    
    private var timer: Timer?
    
    init(state: QuizState, questionPlayer: QuestionPlayer, quizModerator: QuizModerator, reviewer: ReviewState, feedbackMessenger: FeedbackMessageState, listener: ListeningState, presenter: QuizPresenter) {
        
        self.state = state
        self.questionPlayer = questionPlayer
        self.quizModerator = quizModerator
        self.reviewer = reviewer
        self.listener = listener
        self.feedbackMessenger = feedbackMessenger
        self.presenter = presenter
        self.questionPlayer.context = self
        self.quizModerator.context = self
        self.reviewer.context = self
        self.feedbackMessenger.context = self
        self.listener.context = self
        self.presenter.context = self
        setupObservers()
    }
    
    static func create(state: QuizState) -> QuizContext {
        let questionPlayer = QuestionPlayer()
        let moderator = QuizModerator()
        let reviewer = ReviewState()
        let listener = ListeningState()
        let feedbackMessaenger = FeedbackMessageState()
        let presenter = QuizPresenter()
        let context = QuizContext(state: state, questionPlayer: questionPlayer, quizModerator: moderator, reviewer: reviewer, feedbackMessenger: feedbackMessaenger, listener: listener, presenter: presenter)
        
        return context
    }
    
    func setState(_ state: QuizState) {
        print("Setting state to \(type(of: state))")
        self.state = state
        
        if let audioAction = AudioFileSorter.getAudioAction(for: state, context: self) {
            quizContextPlayer.performAudioAction(audioAction)
        } else {
            self.state.handleState(context: self)
        }
  
        notifyObservers()
    }
    
    func handleState(context: QuizContext) {
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
    
    func pauseQuiz() {
        self.questionPlayer.pausePlayback()
    }
    
    func updateDownloadStatus() {
        self.isDownloading = false
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
    
    func prepareMicrophone() {
        if let listeningState = self.state as? ListeningState {
            listeningState.speechRecognizer.prepareMicrophone()
        }
    }
    
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: state)
        }
    }

    private func setupObservers() {
        presenter.$isNowPlaying
            .receive(on: DispatchQueue.main)
            .assign(to: &$isPlaying)
        
        presenter.$hasMoreQuestions
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasMoreQuestions)
        
        presenter.$currentQuestionId
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentQuestionId)
        
        presenter.$currentQuestion
            .map { $0 }
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
    
    private func playFirstQuestion() {
        DispatchQueue.main.async {
            self.presenter.performAction(.startQuiz(self.questions), context: self)
            //self.questionPlayer.playQuestions(self.questions, in: self)
        }
    }
    
}
