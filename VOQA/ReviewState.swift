//
//  ReviewState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

/// State representing the review state of the quiz.
class ReviewState: StateObserver, QuizState {
    
    enum ReviewAction {
        case reviewing
        case doneReviewing
    }
    
    enum ScoreFeedback {
        case noScore
        case tenPercent
        case twentyPercent
        case thirtyPercent
        case fortyPercent
        case fifTyPercent
        case sixtyPercent
        case seventyPercent
        case eigthyPercent
        case ninetyPercent
        case perfectScore
    }
    
    var action: ReviewAction?
    var context: QuizContext?
    var observers: [StateObserver] = []
    
    init(action: ReviewAction? = nil) {
        print("ReviewState handleState called")
        self.action = action
    }
    
    func handleState(context: QuizContext) {
        if let action = self.action {
            performAction(action, context: context)
        }
    }
    
    func performAction(_ action: ReviewAction, context: QuizContext) {
        switch action {
        case .reviewing:
            print("Reviewer reviewing action triggered")
            
            context.currentQuestionText = "Reviewing"
            
            context.quizContextPlayer.performAudioAction(.reviewing)
            
        case .doneReviewing:
            print("Reviewer doneReviewing action triggered")
            
            context.setState(EndedQuizState())
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


