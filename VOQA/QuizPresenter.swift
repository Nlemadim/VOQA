//
//  QuizPresenter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/1/24.
//

import Foundation

class QuizPresenter: QuizState, StateObserver {
    func stateDidChange(to newState: any QuizState) {
        
    }
    
    // QuizState
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }

    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
    
    enum PresenterAction: Equatable {
        static func == (lhs: QuizPresenter.PresenterAction, rhs: QuizPresenter.PresenterAction) -> Bool {
            <#code#>
        }
        
        case startQuiz([Question])
        case presentQuestion
        case presentAnswer
        case noResponse
        case presentMic
        case dismissMic
        case presentOptions
        case routeSession(QuizContext)
        case pausePlay
        case goToNextQuestion
        case repeatQuestion
        case repeatOptions
        case presentReview
        case startQuizPrompt
        case correctAnswerFeedback
        case incorrectAnswerFeedback
        case awaitingResponse
        case quit
    }
    
    @Published var currentQuestionIndex: Int = 0
    @Published var currentQuestion: Question?
    @Published var currentQuestionId: UUID?
    @Published var currentQuestionText: String = ""
    @Published var hasMoreQuestions: Bool = false
    @Published var nowPresentingMic: Bool = false
    
    @Published var isNowPlaying: Bool = false {
        didSet {
            if isPaused {
                isNowPlaying = false
            }
        }
    }
    
    @Published var isPaused: Bool = false {
        didSet {
            if isNowPlaying {
                isPaused = false
            }
        }
    }
    
    @Published var stagedNextState: QuizState?
    
    var context: QuizContext?
    var observers: [StateObserver] = []
    var action: PresenterAction?
    let router = QuizSessionRouter()
    var nextAction: PresenterAction?
    
    var isPresentingMic: Bool?
    var isCheckingAnswer: Bool?
    var isPlayingFeedback: Bool?
    var willPlayCorrectAnswerFeedback: Bool?
    var willPlayInCorrectAnswerFeedback: Bool?
    var willPlayNoResponseFeedback: Bool?
    
    init(action: PresenterAction? = nil, questions: [Question]) {
        self.action = action
        self.questions = questions
    }
    
    
    init(action: PresenterAction? = nil) {
        self.action = action
        self.questions = []
    }
    
    func handleState(context: QuizContext) {
        print("Presenter handleState called")
        
        if let action = self.action {
            performAction(action, context: context)
        }
    }
    
    func startNewQuiz(_ action: PresenterAction, context: QuizContext) {
        self.performAction(action, context: context)
    }
    
    func performAction(_ action: PresenterAction, context: QuizContext? = nil) {
        
        switch action {
            
        case .startQuiz(let questions):
            guard let context = context else { return }
            loadQuestions(questions: questions)
            context.presenter.performAction(.presentQuestion, context: context)
            
        case .presentQuestion:
            
            presentQuestion()
           
        case .presentAnswer:
            presentAnswer()
            
        case .noResponse:
            manageNoResponseFeedback()
            
        case .presentMic:
            manageListenerMicpresentation()
            
        case .routeSession(let context):
            self.router.reRouteQuizSession(context: context)
            
        case .dismissMic:
            manageListenerMicDismissal()
            
        case .pausePlay:
            pausePlayback()
            
        case .goToNextQuestion:
            nextQuestion()
            
        case .correctAnswerFeedback:
            manageCorrectAnswerFeedback()
            
        case .incorrectAnswerFeedback:
            manageIncorrectAnswerFeedback()
            
        case .presentReview:
            presentRevision()
            
        case .awaitingResponse:
            presentOptions()
            
        default:
            break
        }
    }
    
    private func loadQuestions(questions: [Question]) {
        guard !questions.isEmpty else { return }
        self.questions = questions
    }
    
    private var questions: [Question] {
        didSet {
            if let context = context {
                if !context.questions.isEmpty {
                    self.questions = context.questions
                    print("Presenter updated with \(self.questions.count) Questions")
                }
            }
        }
    }
    
    func presentOptions() {
        
    }
    
    
    private func presentQuestion() {
        guard let context = self.context else { return }
        
        let question = questions[currentQuestionIndex]
        let audioUrl = question.audioUrl
        self.currentQuestion = question
        self.currentQuestionText = question.content // Modify with TextFormatter
        self.currentQuestionId = question.id
        
        updateHasMoreQuestions()
        
        isNowPlaying = true
        
        context.setState(context.presenter)
        context.quizContextPlayer.performAudioAction(.playQuestion(url: audioUrl))
        nextAction = .presentMic
        
    }
    
    private func manageListenerMicpresentation() {
        guard let context = self.context else { return }
        self.nowPresentingMic = true
        self.isPresentingMic = true
        
        context.setState(context.presenter)
        context.quizContextPlayer.performAudioAction(.playMicBeeper(.micOn))
        
    }
    
    private func manageListenerMicDismissal() {
        guard let context = self.context else { return }
        
        self.nowPresentingMic = false
        self.isPresentingMic = false
        self.isCheckingAnswer = true
        
        context.setState(context.presenter)
        context.quizContextPlayer.performAudioAction(.playMicBeeper(.micOff))
    }
    
    
    private func nextQuestion() {
        guard let context = self.context else { return }
        
        if hasMoreQuestions {
            
            self.currentQuestionIndex += 1
            
            presentQuestion()
            
        } else {
            
            self.performAction(.presentReview, context: context)
        }
    }
    
    private func pausePlayback() {
        guard let context = self.context else { return }
        
        self.isPaused = true
        context.quizContextPlayer.performAudioAction(.pausePlay)
    }
    
    private func updateHasMoreQuestions() {
        self.hasMoreQuestions = currentQuestionIndex < questions.count - 1
    }
    
    private func presentAnswer() {
        guard let context = self.context else { return }
        
        //MARK: Yet to be defined
        guard !questions.isEmpty else {
            //Undefined action
            performAction(.startQuizPrompt, context: context)
            return
        }
        
        let question = questions[currentQuestionIndex]
        let answerUrl = question.correctionScriptUrl
        
        isNowPlaying = true
        context.setState(context.presenter)
        context.quizContextPlayer.performAudioAction(.playAnswer(url: answerUrl))
    }
    
    private func manageIncorrectAnswerFeedback() {
        isNowPlaying = true
        playFeedbackMessage(action: .incorrectAnswer)
    }
    
    private func manageNoResponseFeedback() {
        isNowPlaying = true
        playFeedbackMessage(action: .noResponse)
    }
        
  
    private func manageCorrectAnswerFeedback() {
        self.willPlayCorrectAnswerFeedback = true
        playFeedbackMessage(action: .correctAnswer)
    }
    
    private func presentRevision() {
        guard let context = self.context else { return }
        
        isNowPlaying = true
        context.setState(context.reviewer)
        context.reviewer.performAction(.reviewing, context: context)
    }
    
    private func playFeedbackMessage(action: FeedbackAction) {
        guard let context = self.context else { return }
        
        isNowPlaying = true
        context.setState(context.feedbackMessenger)
        context.feedbackMessenger.performAction(action, context: context)
    }
    
    func stageNextState(state: QuizState) {
        self.stagedNextState = context
    }
}


class QuizSessionRouter {
    func reRouteQuizSession(context: QuizContext) {
        
        if context.state is QuizPresenter {
            print("Presenter is Re-Routing")
            print("Presenter is in active Quiz: \(context.activeQuiz)")
            context.presenter.isNowPlaying = false
            
            
            if context.activeQuiz {
                if context.presenter.isPresentingMic ?? false {
                    
                    context.setState(context.listener)
                    context.listener.performAction(.prepareMicrophone, context: context)
                    
                } else if context.presenter.isCheckingAnswer ?? false {
                    
                    context.setState(context.questionPlayer)
                    context.quizModerator.performAction(.validateSpokenResponse, context: context)
                    
                } else if context.presenter.willPlayCorrectAnswerFeedback ?? false {
                    
                }
                
                print("Presenter next action: \(String(describing: context.presenter.nextAction))")
                /// Presenter will take next immediate action if any else pass to nextState
                if let nextAction = context.presenter.nextAction {
                    context.setState(context.presenter)
                    context.presenter.performAction(nextAction)
                    print("Performing: \(nextAction) action")
                    
                } else if let stagedState = context.presenter.stagedNextState {
                    
                    if stagedState is ListeningState {
                        print("Current state: \(stagedState)")
                        context.setState(context.listener)
                        context.listener.performAction(.prepareMicrophone, context: context)
                        context.presenter.stageNextState(state: context.quizModerator)
                        print("Ready for next state: \(String(describing: context.presenter.stagedNextState))")
                    } else {
                        
                        print("Assigned state was: \(stagedState))")
                    }
                    
                } else {
                    
                    print("Assigned NO state was)")
                }
                

                
                
                
            }
            
            //Return from MicBeep context player DidFinishPlaying method
//            if context.presenter.nowPresentingMic {
//                
//            } else {
//                context.setState(context.quizModerator)
//                context.quizModerator.performAction(.validateSpokenResponse, context: context)
//            }
//            
//            if context.activeQuiz {
//                if context.presenter.hasMoreQuestions {
//                    context.presenter.performAction(.goToNextQuestion, context: context)
//                } else {
//                    context.presenter.performAction(.presentMic, context: context)
//                    context.activeQuiz = false
//                }
//            } else {
//                context.presenter.performAction(.presentReview, context: context)
//            }
        }
        
        if context.state is FeedbackMessageState {
            print("Presenter is transferring state to Feedback Messenger")
            
            if context.activeQuiz && context.presenter.hasMoreQuestions  {
                
                context.setState(context.presenter)
                
                context.presenter.performAction(.goToNextQuestion, context: context)
                
            } else {
                
                context.presenter.performAction(.presentReview, context: context)
            }
        }
        
        if context.state is ReviewState {
            print("Presenter is transferring state back to Reviewer")
            
            context.reviewer.performAction(.doneReviewing, context: context)
        }
        
        if context.state is ListeningState {
            
            context.quizModerator.performAction(.validateSpokenResponse, context: context)
        }
    }
}

class PresentationTextFormatter {
    
}
