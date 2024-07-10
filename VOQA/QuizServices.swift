//
//  QuizServices.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation

/// Protocol representing a state in the quiz.
protocol QuizServices {
    var observers: [SessionObserver] { get set }
    
    /// Handles the logic associated with this state.
    func handleState(session: QuizSession)
    
    /// Adds an observer to the state.
    func addObserver(_ observer: SessionObserver)
    
    /// Notifies all observers about the state change.
    func notifyObservers()
}

protocol SessionObserver: AnyObject {
    func stateDidChange(to newState: QuizServices)
}

