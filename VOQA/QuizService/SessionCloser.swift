//
//  SessionCloser.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation
import Combine


/// State representing the started quiz state of the quiz.
class SessionCloser: SessionObserver, QuizServices {
    
    enum CloseSessionAction {
        case quitAndReset
        case refreshQuestions
        case downloadNewQuestions
        case downloaded
    }
    
    var action: CloseSessionAction?
    var context: QuizSession?
    var observers: [SessionObserver] = []
    
    init(action: CloseSessionAction? = nil) {
        self.action = action
    }
    
    
    func addObserver(_ observer: any SessionObserver) {}
    
    func notifyObservers() {}
        
    func handleState(context: QuizSession) {
        context.activeQuiz = false
        // Handle any additional logic for ending the quiz, such as reloading questions for future implementation
        notifyObservers()
    }
    
    func stateDidChange(to newState: any QuizServices) {}
   
    
}

