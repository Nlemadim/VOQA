//
//  IdleSession.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation

class IdleSession: QuizServices {
    
    var observers = [SessionObserver]()

    func handleState(session: QuizSession) {
        // Handle idle state logic
        notifyObservers()
    }
    
    
    func addObserver(_ observer: SessionObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
}
