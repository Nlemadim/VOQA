//
//  QuizModerator.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//


import Foundation
import AVFoundation

class QuizModerator: NSObject, ObservableObject, AVAudioPlayerDelegate, StateObserver, QuizState {
    
    enum ModeratorAction {
        case validateSpokenResponse
        case checkStatus
        case prepareNextQuestion
        case proceedWithQuiz
        case review
    }
    
    enum ValidationFeedback {
        case noFeedback
        case noResponseFeedback
        case correctAnswerFeedback
        case incorrectAnswerFeedback
        case goToNextQuestion
    }
    
    var isFeedbackEnabled = true//UserDefaultsManager.isQandAEnabled() // returns a bool to know if to play the answer or not
    var context: QuizContext?
    var action: ModeratorAction?
    var validationFeedback: ValidationFeedback?
    var responseTime: TimeInterval = 5.0 // Default response time
    private var audioPlayer: AVAudioPlayer?
    var observers: [StateObserver] = []
    var getNewQuestion: Bool = false

    init(action: ModeratorAction? = nil) {
        self.action = action
        
    }
    
    func handleState(context: QuizContext) {
        if let action = self.action {
            performAction(action, context: context)
        }
    }
    
    func performAction(_ action: ModeratorAction, context: QuizContext) {
        switch action {
        case .validateSpokenResponse:
            print("Moderator validateSpokenResponse action triggered")
         
            validateResponse(context.spokenAnswerOption, for: context.currentQuestionId ?? UUID())
            
        case .proceedWithQuiz:
            print("Moderator proceedWithQuiz action triggered")
            
            context.setState(context.questionPlayer)
            
            context.questionPlayer.performAction(.playNextQuestion, context: context)
            
        case .review:
            print("Moderator review action triggered")
            
            context.hasMoreQuestions = false
            context.setState(ReviewState(action: .reviewing))
            
        case .prepareNextQuestion:
            goToNextQuestion()
            
        case .checkStatus:
            checkQuestionStatus()
        }
    }
    
    private func playFeedbackMessage(action: FeedbackAction, context: QuizContext) {
        
        context.setState(context.feedbackMessenger)
        
        context.feedbackMessenger.performAction(action, context: context)
    }
    
//    private func transitionToNextState() {
//        print("Moderator transitionToNextState called")
//        
//        guard let context = context else {
//            print("Context is nil, exiting transitionToNextState")
//            return
//        }
//        
//        print("Current Question Index: \(context.questionPlayer.currentQuestionIndex)")
//        print("Total Questions: \(context.questionPlayer.questions.count)")
//        print("Has More Questions: \(context.questionPlayer.hasMoreQuestions)")
//        
//        if context.questionPlayer.hasMoreQuestions {
//            self.getNewQuestion = true
//            goToNextQuestion()
//        }
//    }
    
    func checkQuestionStatus() {
        guard let context = context else { return }
        if context.questionPlayer.hasMoreQuestions {
            self.performAction(.prepareNextQuestion, context: context)
        } else {
            self.performAction(.review, context: context)
        }
    }
    
    func goToNextQuestion() {
        guard let context = context else { return }
        
        context.quizContextPlayer.performAudioAction(.nextQuestion)
        
        context.questionPlayer.currentQuestionIndex += 1
        
        context.updateQuestionCounter(questionIndex: context.questionPlayer.currentQuestionIndex, count: context.questions.count)
    
    }
    
    func validateResponse(_ response: String, for questionId: UUID) {
        guard let context = context else { return }
        print("Moderator validateResponse called with response: \(response) for questionId: \(questionId)")
        
        guard let question = context.questions.first(where: { $0.id == questionId }) else {
            print("No question found for the given questionId")
            return
        }
        
        print("Correct answer for question: \(question.correctOption)")
        
        if response.lowercased().isEmptyOrWhiteSpace {
           
            print("Response is empty or whitespace")
            
            if isFeedbackEnabled {
                print("isQandA is true, playing no response callout")
                
                playFeedbackMessage(action: .noResponse, context: context)
                
            } else {
                print("isQandA is false, transitioning to next state")
                
                self.performAction(.checkStatus, context: context)
            }
        } else if response.lowercased() == question.correctOption.lowercased() {
            
            print("Response is correct")
            
            if isFeedbackEnabled {
                
                print("isQandA is true, playing correct answer callout")
                
                playFeedbackMessage(action: .correctAnswer, context: context)
            
                
            } else {
                
                print("isQandA is false, transitioning to next state")
                
                self.performAction(.checkStatus, context: context)
            }
        } else {
            
            print("Response is incorrect")
            
            if isFeedbackEnabled {
                
                print("isQandA is true, playing wrong answer callout")
                
                playFeedbackMessage(action: .incorrectAnswer, context: context)
               
            } else {
                print("isQandA is false, transitioning to next state")
                
                self.performAction(.checkStatus, context: context)
            }
        }
    }

    // StateObserver
    func stateDidChange(to newState: QuizState) {
        // Handle state changes if needed
    }

    // QuizState
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }

    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
}

