//
//  ResponsePresenter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation

/// State representing the awaiting response state of the quiz.
/// Presents Mic through its ListnerClass
class ResponsePresenter: SessionObserver, QuizServices {
    
    enum PresentationAction {
        case presentMic
        case presentButtons
        case dismissResponsePresentation
    }
    
    @Published var isAwaitingResponse: Bool = true
    @Published var userResponse: String?
    
    var session: QuizSession?
    var observers: [SessionObserver] = []
    var responsePresentation: PresentationAction?
    
    init(action: PresentationAction? = nil) {
        self.responsePresentation = action
    }
    
    func handleState(context: QuizSession) {
        print("Response Presenter handleState called")
        
        if let responsePresentation = self.responsePresentation {
            performAction(responsePresentation, session: context)
        }
    }
    
    func performAction(_ action: PresentationAction, session: QuizSession) {
        switch responsePresentation {
        case .presentMic:
            session.sessionAudioPlayer.performAudioAction(.waitingFoprResponse)
        case .presentButtons:
            session.sessionAudioPlayer.performAudioAction(.waitingFoprResponse)
            session.isAwaitingResponse = true
        case .dismissResponsePresentation:
            session.sessionAudioPlayer.performAudioAction(.recievedResponse)
            session.isAwaitingResponse = false
        case nil:
            break
        }
    }
    

    func addObserver(_ observer: any SessionObserver) {}
    func notifyObservers() {}
    func stateDidChange(to newState: any QuizServices) {}
    
    
    
}


