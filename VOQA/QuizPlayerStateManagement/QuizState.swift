//
//  QuizState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//  All rights reserved.

import Foundation

/// Base class for all states in the quiz.
class BaseState: QuizState {
    var observers = [StateObserver]()
    
    func handleState(context: QuizContext) {
        // Default implementation
    }
    
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
}

/// State representing the idle state of the quiz.
class IdleState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle idle state logic
        notifyObservers()
    }
}


/// State representing the awaiting response state of the quiz.
class AwaitingResponseState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle awaiting response state logic
        notifyObservers()
    }
}

/// State representing the processing state of the quiz.
class ProcessingState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle processing state logic
        notifyObservers()
    }
}

/// State representing the started quiz state of the quiz.
class StartedQuizState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle started quiz logic
        notifyObservers()
    }
}

/// State representing the started quiz state of the quiz.
class EndedQuizState: BaseState {
    override func handleState(context: QuizContext) {
        context.activeQuiz = false
        // Handle any additional logic for ending the quiz, such as reloading questions for future implementation
        notifyObservers()
    }
}


