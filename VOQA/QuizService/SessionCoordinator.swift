//
//  SessionCoordinator.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation
import Combine

class SessionCoordinator: QuizServices, SessionObserver {
    enum RouteSessionAction {
        case routeToQuestionPlayer
        case routeToValidationManager
        case routeToReviewManager
        case routeToResponsePresenter
        case routeToSessionCloser
        case reRouteAndSynchronize
    }
    
    var session: QuizSession?
    var observers: [SessionObserver] = []
    var action: RouteSessionAction?
    var nextAction: RouteSessionAction?
    var isReadyForNextQuestion: Bool = false
    
    init(action: RouteSessionAction? = nil) {
        self.action = action
    }
    
    func handleState(context: QuizSession) {
        print("Presenter handleState called")
        
        if let action = self.action {
            performAction(action, session: context)
        }
    }
    
    func startNewQuiz(_ action: RouteSessionAction, session: QuizSession) {
        self.performAction(action, session: session)
    }
    
    func performAction(_ action: RouteSessionAction, session: QuizSession) {
        switch action {
            
        case .routeToQuestionPlayer:
            routeToQuestionPlayer()
            
        case .routeToValidationManager:
            routeToValidator()
            
        case .routeToReviewManager:
            routeToReviewer()
            
        case .routeToResponsePresenter:
            routeToResponsePresenter()
            
        case .routeToSessionCloser:
            routeToSessionCloser()

        case .reRouteAndSynchronize:
            
            if session.state is SessionCoordinator {
                if self.isReadyForNextQuestion {
                    self.performAction(.routeToQuestionPlayer, session: session)
                }
            }
            
            if session.state is QuestionPlayer {
                self.performAction(.routeToResponsePresenter, session: session)
            }
            
            if session.state is ResponsePresenter {
                if session.isAwaitingResponse {
                    return // Start Timer will be called here in the future
                } else {
                    self.performAction(.routeToValidationManager, session: session)
                }
            }
            
            if session.state is ResponseValidationManager {
                if session.hasMoreQuestions {
                    prepareForNextQuestion()
                } else {
                    self.performAction(.routeToReviewManager, session: session)
                }
            }
            
            if session.state is ReviewsManager {
                self.performAction(.routeToSessionCloser, session: session)
            }
        }
    }
    
    private func prepareForNextQuestion() {
        guard let session = self.session else { return }
        session.setState(session.sessionCoordinator)
        self.isReadyForNextQuestion = true
        session.sessionAudioPlayer.performAudioAction(.nextQuestion)
    }
    
    private func routeToReviewer() {
        guard let session = self.session else { return }
    
        session.setState(session.reviewer)
        session.reviewer.performAction(.reviewing, context: session)
    }
    
    private func routeToResponsePresenter() {
        guard let session = self.session else { return }
    
        session.setState(session.responsePresenter)
        session.responsePresenter.performAction(.presentButtons, session: session)
    }
    
    private func routeToValidator() {
        guard let session = self.session else { return }
    
        session.setState(session.responseValidator)
        session.responseValidator.performAction(action: .validateResponse, session: session)
    }
    
    private func routeToSessionCloser() {
        guard let session = self.session else { return }
    
        session.setState(session.sessionCloser)
        //session.responseValidator.performAction(action: .validateResponse, session: session)
    }
    
    private func routeToQuestionPlayer() {
        guard let session = self.session else { return }
        
        self.isReadyForNextQuestion = false
        session.setState(session.questionPlayer)
        session.questionPlayer.performAction(.readyToPlayNextQuestion, session: session)
    }
    
    func stateDidChange(to newState: any QuizServices) {
        
    }
    
    // QuizState
    func addObserver(_ observer: SessionObserver) {
        observers.append(observer)
    }

    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
    
}

