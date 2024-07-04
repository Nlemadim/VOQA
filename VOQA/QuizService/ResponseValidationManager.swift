//
//  ResponseValidationManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation
import Combine

class ResponseValidationManager: SessionObserver, QuizServices {
    
    enum ResponseValidationFeedback {
        case noResponse
        case inCorrectAnswer
        case correctAnswer
        case invalidResponse
        case noFeedback
    }
    
    enum ValidationAction {
        case validateResponse
    }
    
    var session: QuizSession?
    var responseFeedback: ResponseValidationFeedback?
    var action: ValidationAction?
    var observers: [SessionObserver] = []
    
    init(session: QuizSession) {
        self.session = session
        self.responseFeedback = nil
    }
    
    init(action: ValidationAction? = nil) {
        self.action = action
    }
    
    func handleState(context: QuizSession) {
        if let action = self.action {
            if let currentQuestionId = context.currentQuestionId {
                performAction(action: .validateResponse, session: context)
            }
        }
    }
    
    func performAction(action: ValidationAction, session: QuizSession) {
        switch action {
        case .validateResponse:
            print("Validating Response")
            performValidationAction()
       
        }
    }
    
    private func performValidationAction() {
        guard let session = session else { return }
        guard let question = session.currentQuestion else { return }
        let response = session.buttonSelected
        

        if response.isEmptyOrWhiteSpace {
            
            //MARK TODO: Add a property to Question that checks if was presented and number of times presented
            
            performValidationFeedbackAction(feedbackType: .noResponse, session: session)
            //Transfer Session to Coordinator
            
        } else if response.lowercased() == question.correctOption.lowercased() {
//            question.selectedOption = response
//            question.isAnswered = true
//            question.isAnsweredCorrectly = true
            
            performValidationFeedbackAction(feedbackType: .correctAnswer, session: session)
            //Transfers Session to Coordinator
            
        } else {
//            question.selectedOption = response
//            question.isAnswered = true
//            question.isAnsweredCorrectly = false
            
            performValidationFeedbackAction(feedbackType: .inCorrectAnswer, session: session)
            //Transfers Session to Coordinator from Player
        }
    }
    
    private func performValidationFeedbackAction(feedbackType: ResponseValidationFeedback, session: QuizSession) {
        print("Now Playing Validation Feedback")
        switch feedbackType {
        case .noResponse:
            session.sessionAudioPlayer.performAudioAction(.playNoResponseCallout)
        case .inCorrectAnswer:
            session.sessionAudioPlayer.performAudioAction(.playWrongAnswerCallout)
        case .correctAnswer:
            session.sessionAudioPlayer.performAudioAction(.playCorrectAnswerCallout)
        case .invalidResponse:
            session.sessionAudioPlayer.performAudioAction(.playNoResponseCallout)
        case .noFeedback:
            session.sessionAudioPlayer.performAudioAction(.nextQuestion)
        }
    }
    
    // StateObserver
    func stateDidChange(to newState: QuizServices) {
        // Handle state changes if needed
    }

    // QuizSession
    func addObserver(_ observer: SessionObserver) {
        observers.append(observer)
    }

    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
}

