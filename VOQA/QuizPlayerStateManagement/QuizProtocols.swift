//
//  QuizProtocols.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation

/// Protocol representing a state in the quiz.
protocol QuizState {
    var observers: [StateObserver] { get set }
    
    /// Handles the logic associated with this state.
    func handleState(context: QuizContext)
    
    /// Adds an observer to the state.
    func addObserver(_ observer: StateObserver)
    
    /// Notifies all observers about the state change.
    func notifyObservers()
}

protocol StateObserver: AnyObject {
    func stateDidChange(to newState: QuizState)
}

