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
    
    enum EndSessionActions {
        case quitAndReset
        case refreshQuestions
        case downloadNewQuestions
        case downloaded
    }
    
    var action: EndSessionActions?
    var context: QuizSession?
    var observers: [SessionObserver] = []
    
    init(action: EndSessionActions? = nil) {
        self.action = action
    }
    
    func performAction(_ action: EndSessionActions, session: QuizSession) {
        switch action {
        case .quitAndReset:
            resetSession(session: session)
        default:
            break
        }
    }
    
    func resetSession(session: QuizSession) {
        self.sessionReset(session: session)
        session.setState(IdleSession())
    }
    
    private func sessionReset(session: QuizSession) {
        session.activeQuiz = false
        session.countdownTime = 5.0
        session.currentQuestionText = "Quiz Complete"
        session.questionCounter = "0 Questions"
        session.totalQuestionCount = 0
        session.finalScore = 0
        session.scoreRegistry.currentScore = 0
        session.dynamicContentManager.hasFetchedSessionIntro = false
        session.dynamicContentManager.dynamicSessionIntro = nil
        session.dynamicContentManager.dynamicReviewUrl = ""
        session.questionPlayer.resetQuestionIndex()

        session.quizTimer = 0.0
    }
    
    
    func addObserver(_ observer: any SessionObserver) {}
    
    func notifyObservers() {}
        
    func handleState(session: QuizSession) {
        session.activeQuiz = false
        // Handle any additional logic for ending the quiz, such as reloading questions for future implementation
        notifyObservers()
    }
    
    func stateDidChange(to newState: any QuizServices) {}
   
    
}

