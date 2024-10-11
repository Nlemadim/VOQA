//
//  ReviewsManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation

/// State representing the review state of the quiz.
class ReviewsManager: SessionObserver, QuizServices {
    
    enum ReviewAction {
        case reviewing
        case doneReviewing
        case giveScore
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
    var session: QuizSession?
    var observers: [SessionObserver] = []
    
    func handleState(session: QuizSession) {
        if let action = self.action {
            performAction(action, session: session)
        }
    }
    
    func performAction(_ action: ReviewAction, session: QuizSession) {
        switch action {
        case .reviewing:
            print("Reviewer reviewing action triggered")
            
            session.currentQuestionText = "Reviewing"
           // session.sessionAudioPlayer.performAudioAction(.dynamicReview)
            
        case .doneReviewing:
            print("Reviewer doneReviewing action triggered")
            
            session.setState(session.sessionCloser)
            session.sessionCloser.performAction(.quitAndReset, session: session)
        case .giveScore:
            print("Reviewer give score action triggered")
            
            session.sessionAudioPlayer.performAudioAction(.giveScore(score: session.finalScore))
        }
    }
    
    // StateObserver
    func stateDidChange(to newState: QuizServices) {
        // Handle state changes if needed
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


