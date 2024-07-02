//
//  FeedBackMessage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation

enum FeedbackAction {
    case correctAnswer
    case incorrectAnswer
    case noResponse
    case transcriptionError
    case proceedWithQuiz
}

/// State representing the feedback message state of the quiz.
class FeedbackMessageState: StateObserver, QuizState {
    
    var action: FeedbackAction?
    var context: QuizContext?
    var observers: [StateObserver] = []
    var feedbackMessages: [VoiceFeedbackMessages] = []
    
    init(action: FeedbackAction? = nil) {
        self.action = action
        print("Feedback Player Initialized")
    }
    
    func handleState(context: QuizContext) {
        if let action = self.action {
            performAction(action, context: context)
        }
    }

    func performAction(_ action: FeedbackAction, context: QuizContext) {
        switch action {
        case .correctAnswer:
            
            context.quizContextPlayer.performAudioAction(.playCorrectAnswerCallout)
            
        case .incorrectAnswer:
            
            context.quizContextPlayer.performAudioAction(.playWrongAnswerCallout)
            
        case .noResponse:
            
            context.quizContextPlayer.performAudioAction(.playNoResponseCallout)
            
        case .transcriptionError:
            
            context.quizContextPlayer.performAudioAction(.playNoResponseCallout)
            
        case .proceedWithQuiz:
            
            context.setState(context.quizModerator)
            
            context.quizModerator.performAction(.proceedWithQuiz, context: context)
        }
    }
    
    // StateObserver
    func stateDidChange(to newState: QuizState) {
        // Handle state changes if needed
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
}
