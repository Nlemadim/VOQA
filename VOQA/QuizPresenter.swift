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
    
    enum PresenterAction {
        case presentQuestion(String)
        case presentAnswer(String)
        case presentMic(Beeper)
        case dismissMic(Beeper)
        case presentOptions
        case routeSession
    }
    
    @Published var questions: [Question]
    @Published var currentQuestionIndex: Int = 0
    
    var context: QuizContext?
    var observers: [StateObserver] = []
    var action: PresenterAction?
    let router = QuizSessionRouter()

    init(action: PresenterAction? = nil, questions: [Question] = []) {
        self.action = action
        self.questions = questions
    }
    
    func handleState(context: QuizContext) {
        print("QuestionPlayer handleState called")
        
        if let action = self.action {
            performAction(action, context: context)
        }
    }
    
    func performAction(_ action: PresenterAction, context: QuizContext) {
        
        switch action {
            
        case .presentQuestion(let question):
            context.quizContextPlayer.performAudioAction(.playQuestion(url: questions[currentQuestionIndex].correctOption))
            
        case .presentAnswer(let string):
            context.quizContextPlayer.performAudioAction(.playQuestion(url: questions[currentQuestionIndex].audioUrl))
            
        case .presentMic(let beeper):
            context.quizContextPlayer.performAudioAction(.playMicBeeper(.micOn))
        
        case .routeSession:
            self.router.reRouteQuizSession(context: context)
            
        case .dismissMic(_):
            context.quizContextPlayer.performAudioAction(.playMicBeeper(.micOff))
            
        default:
            break
        }
    }
}


class QuizSessionRouter {
    func reRouteQuizSession(context: QuizContext) {
        
        if context.state is QuizModerator {
            print("Presenter is transferring state back to Moderator")
            
            context.quizModerator.performAction(.proceedWithQuiz, context: context)
        }
        
        if context.state is FeedbackMessageState {
            print("Presenter is transferring state back to Feedback Messenger")
            
            context.feedbackMessenger.performAction(.proceedWithQuiz, context: context)
        }
        
        if context.state is ReviewState {
            print("Presenter is transferring state back to Reviewer")
            
            context.reviewer.performAction(.reviewing, context: context)
        }
        
        if context.state is ListeningState {
            print("Presenter is transferring state back to Listening State")
            
            if context.isListening {
                context.listener.performAction(.prepareMicrophone, context: context)
            } else {
                context.listener.performAction(.proceedWithQuiz, context: context)
            }
        }
    }
}
