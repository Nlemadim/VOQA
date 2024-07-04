//
//  QuestionPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/26/24.
//

import Foundation
import AVFoundation
import Combine


class QuestionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, SessionObserver, QuizServices {
    
    enum QuestionPlayerAction {
        case loadNewSessionQuestions
        case playCurrentQuestion(Question)
        case readyToPlayNextQuestion
        case noQuestions
    }
    
    

    @Published var isPlayingQuestion: Bool = false
    @Published var hasMoreQuestions: Bool = false
    @Published var currentQuestionIndex: Int = 0
    @Published var currentQuestionId: UUID?
    @Published var currentQuestion: Question?
    
    var questions: [Question] = []
    
    var session: QuizSession?
    var observers: [SessionObserver] = []
    var action: QuestionPlayerAction?

    init(action: QuestionPlayerAction? = nil) {
        self.action = action
        super.init()
    }
    
    func handleState(context: QuizSession) {
        print("QuestionPlayer handleState called")
        
        if let action = self.action {
            performAction(action, session: context)
        }
    }
    
    func performAction(_ action: QuestionPlayerAction, session: QuizSession) {
        print("QuestionPlayer performAction called with action: \(action)")
        print("Current Question Index: \(currentQuestionIndex)")
        print("Total Questions: \(questions.count)")
        
        switch action {
            
        case .loadNewSessionQuestions:
            loadQuestions(session: session)
            
        case .playCurrentQuestion:
            playQuestion()
            
        case .readyToPlayNextQuestion:
            prepareNextQuestion(session: session)
            
        case .noQuestions:
            session.sessionAudioPlayer.performAudioAction(.playNoResponseCallout)
            print("Error No Questios available")
        }
    }
    
    private func loadQuestions(session: QuizSession) {
        guard !session.questions.isEmpty else {
            performAction(.noQuestions, session: session)
            return
        }
        
        self.questions = session.questions
        let currentIndex = self.currentQuestionIndex
        let currentQuestion = self.questions[currentIndex]
        
        session.updateQuestionCounter(questionIndex: currentIndex, count: questions.count)
        
        performAction(.playCurrentQuestion(currentQuestion), session: session)
    }
    
    private func playQuestion() {
        guard let session = session else { return }
        
        let question = questions[currentQuestionIndex]
        self.currentQuestion = question
        self.currentQuestionId = question.id
        updateHasNextQuestion()
        
        session.sessionAudioPlayer.performAudioAction(.playQuestion(url: question.audioUrl))
    
        print("Question Player Presenting question with ID: \(question.id)")
        print("Question Player has More Questions: \(self.hasMoreQuestions)")
    }

    private func updateHasNextQuestion() {
        hasMoreQuestions = currentQuestionIndex < questions.count - 1
    }
    
    private func prepareNextQuestion(session: QuizSession) {
        self.currentQuestionIndex += 1
        let currentIndex = self.currentQuestionIndex
        let currentQuestion = self.questions[currentIndex]
        performAction(.playCurrentQuestion(currentQuestion), session: session)
    }

    private func proceedToNextQuestion() {
        guard let session = session else { return }
        self.performAction(.readyToPlayNextQuestion, session: session)
    }

    func addObserver(_ observer: SessionObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
    
    // StateObserver
    func stateDidChange(to newState: QuizServices) {
        print("Question Player state did change to \(type(of: newState))")
        // Handle state changes if needed
    }
}

