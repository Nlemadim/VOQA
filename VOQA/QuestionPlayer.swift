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
        case setSessionQuestions
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
    
    func handleState(session: QuizSession) {
        print("QuestionPlayer handleState called")
        
        if let action = self.action {
            performAction(action, session: session)
        }
    }
    
    func performAction(_ action: QuestionPlayerAction, session: QuizSession) {
        print("QuestionPlayer performAction called with action: \(action)")
        print("Current Question Index: \(currentQuestionIndex)")
        print("Total Questions: \(questions.count)")
        
        switch action {
            
        case .setSessionQuestions:
            loadQuestions(session: session)
            
        case .playCurrentQuestion:
            playQuestion()
            
        case .readyToPlayNextQuestion:
            prepareNextQuestion(session: session)
            
        case .noQuestions:
            print("Error No Questios available")
            session.sessionAudioPlayer.performAudioAction(.playNoResponseCallout)
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

        // Ensure currentQuestionIndex is within the bounds of the questions array
        guard self.currentQuestionIndex <= self.questions.count - 1 else {
            session.setState(session.reviewer)
            session.reviewer.performAction(.reviewing, session: session)
            return
        }

        let question = questions[currentQuestionIndex]
        session.currentQuestionText = question.content

        self.currentQuestion = question
        self.currentQuestionId = question.id
        updateHasNextQuestion()

        // Ensure sessionAudioPlayer has the correct context
        session.sessionAudioPlayer.setContext(session)
        
        // Perform the audio action and set the state to QuestionPlayer
        session.sessionAudioPlayer.performAudioAction(.playQuestionAudioUrl(url: question.audioUrl))
        session.setState(self)
        
        print("Question Player Presenting question with ID: \(question.id)")
        print("Question Player has More Questions: \(self.hasMoreQuestions)")
        print("Question Player currentIndex: \(self.currentQuestionIndex)")
    }

    
//    private func playQuestion() {
//        guard let session = session else { return }
//        
//        guard self.currentQuestionIndex <= self.questions.count - 1 else {
//            session.setState(session.reviewer)
//            session.reviewer.performAction(.reviewing, session: session)
//            return
//        }
//        
//        let question = questions[currentQuestionIndex]
//        session.currentQuestionText = question.content
//        
//        self.currentQuestion = question
//        self.currentQuestionId = question.id
//        updateHasNextQuestion()
//        
//        session.sessionAudioPlayer.performAudioAction(.playQuestionAudioUrl(url: question.audioUrl))
//    
//        print("Question Player Presenting question with ID: \(question.id)")
//        print("Question Player has More Questions: \(self.hasMoreQuestions)")
//        print("Question Player currentIndex: \(self.currentQuestionIndex)")
//    }

    private func updateHasNextQuestion() {
        hasMoreQuestions = currentQuestionIndex < questions.count - 1
        if let session = session {
            if currentQuestionIndex == questions.count - 1 {
                DispatchQueue.main.async {
                    session.hasAskedLastQuestion = true
                }
            }
        }
    }
    
    private func prepareNextQuestion(session: QuizSession) {
        let currentIndex = self.currentQuestionIndex
        session.currentQuestionText = "Next Question"
        self.currentQuestionIndex += 1
        let currentQuestion = self.questions[currentIndex]
        performAction(.playCurrentQuestion(currentQuestion), session: session)
        
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

