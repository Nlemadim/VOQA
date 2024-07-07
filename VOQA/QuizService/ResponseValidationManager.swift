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
    
    func handleState(session: QuizSession) {
        performAction(action: .validateResponse, session: session)
    }
    
    private func performValidationAction() {
        guard let session = session else { return }
        guard let question = session.currentQuestion else { return }
        
        let response = session.buttonSelected
        
        if response.isEmptyOrWhiteSpace {
            
            performValidationFeedbackAction(feedbackType: .noResponse, session: session)
            
        } else if response.lowercased() == question.correctOption.lowercased() {

            performValidationFeedbackAction(feedbackType: .correctAnswer, session: session)
         
        } else {

            performValidationFeedbackAction(feedbackType: .inCorrectAnswer, session: session)
        
        }
    }
    
    private func performValidationFeedbackAction(feedbackType: ResponseValidationFeedback, session: QuizSession) {
        
        switch feedbackType {
        case .noResponse:
            print("Now Playing Validation no response Feedback")
            session.sessionAudioPlayer.performAudioAction(.playNoResponseCallout)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                self.performAction(action: .validated, session: session)
//            }

        case .inCorrectAnswer:
            print("Now Playing Validation no incorrect answer Feedback")
            session.sessionAudioPlayer.performAudioAction(.playWrongAnswerCallout)
            
            session.setState(session.questionPlayer)
            session.questionPlayer.performAction(.readyToPlayNextQuestion, session: session)
            
        case .correctAnswer:
            print("Now Playing Validation no correct answer Feedback")
            session.sessionAudioPlayer.performAudioAction(.playCorrectAnswerCallout)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                self.resumeSession(session: session)
            }
            
        case .invalidResponse:
            print("Now Playing Validation no response Feedback")
            session.sessionAudioPlayer.performAudioAction(.playNoResponseCallout)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                self.resumeSession(session: session)
            }
            
        case .noFeedback:
            print("Validation:- no Feedback")
            session.sessionAudioPlayer.performAudioAction(.nextQuestion)
        }
    }
    
    func performAction(action: ValidationAction, session: QuizSession) {
        switch action {
        case .validateResponse:
            performValidationAction()
            
            print("Validating Response")
        }
    }
    
    func resumeSession(session: QuizSession) {
        print("Ready to resume session")
        session.sessionAudioPlayer.performAudioAction(.nextQuestion)
       
        
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

