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
    }
    
    var isQandA = UserDefaultsManager.isQandAEnabled() // returns a bool to know if to play the answer or not
    var context: QuizContext?
    var action: ModeratorAction?
    var responseTime: TimeInterval = 5.0 // Default response time
    private var audioPlayer: AVAudioPlayer?
    var observers: [StateObserver] = []

    init(action: ModeratorAction? = nil) {
        self.action = action
    }
    
    func handleState(context: QuizContext) {
        if let action = self.action {
            performAction(action, context: context)
        }
    }
    
    private func performAction(_ action: ModeratorAction, context: QuizContext) {
        switch action {
        case .validateSpokenResponse:
            print("Moderator validateSpokenResponse action triggered")
            validateResponse(context.spokenAnswerOption, for: context.currentQuestionId ?? UUID())
        }
    }

    func startQuiz() {
        context?.activeQuiz = true
        context?.setState(StartedQuizState())
    }
    

    func validateResponse(_ response: String, for questionId: UUID) {
        print("Moderator validateResponse called with response: \(response) for questionId: \(questionId)")
        
        guard let question = context?.questions.first(where: { $0.id == questionId }) else {
            print("No question found for the given questionId")
            return
        }
        
        print("Correct answer for question: \(question.correctOption)")
        
        if response.lowercased().isEmptyOrWhiteSpace {
            print("Response is empty or whitespace")
            if isQandA {
                print("isQandA is true, playing no response callout")
                playNoResponseCallout()
            } else {
                print("isQandA is false, transitioning to next state")
                transitionToNextState()
            }
        } else if response.lowercased() == question.correctOption.lowercased() {
            print("Response is correct")
            if isQandA {
                print("isQandA is true, playing correct answer callout")
                playCorrectAnswerCallout()
            } else {
                print("isQandA is false, transitioning to next state")
                transitionToNextState()
            }
        } else {
            print("Response is incorrect")
            if isQandA {
                print("isQandA is true, playing wrong answer callout")
                playWrongAnswerCallout()
            } else {
                print("isQandA is false, transitioning to next state")
                transitionToNextState()
            }
        }
    }


    private func playCorrectAnswerCallout() {
        playSound(fileName: "correctAnswerBell", fileType: "wav")
    }

    private func playWrongAnswerCallout() {
        playSound(fileName: "wrongAnswerBell", fileType: "wav")
    }

    private func playNoResponseCallout() {
        playSound(fileName: "errorBell", fileType: "wav")
    }

    private func transitionToNextState() {
        print("Moderator transitionToNextState called")
        
        guard let context = context else {
            print("Context is nil, exiting transitionToNextState")
            return
        }
        
        print("Current Question Index: \(context.questionPlayer.currentQuestionIndex)")
        print("Total Questions: \(context.questionPlayer.questions.count)")
        print("Has More Questions: \(context.questionPlayer.hasMoreQuestions)")
        
        if context.questionPlayer.hasMoreQuestions {
            DispatchQueue.main.async {
                context.hasMoreQuestions = true
                print("Proceeding with quiz")
                context.questionPlayer.currentQuestionIndex += 1
                context.updateQuestionCounter(questionIndex: context.questionPlayer.currentQuestionIndex, count: context.questions.count)
                if let nextQuestion = context.questionPlayer.questions[safe: context.questionPlayer.currentQuestionIndex] {
                    context.updateCurrentQuestionId(nextQuestion.id)
                }
                context.setState(context.questionPlayer)
                // just added this line
                context.questionPlayer.performAction(.playNextQuestion, context: context)
                print("Set state to existing QuestionPlayer with action .playNextQuestion")
            }
        } else {
            context.hasMoreQuestions = false
            context.setState(ReviewState(action: .reviewing))
            print("Set state to ReviewState with action .reviewing")
        }
    }

    func endQuiz() {
        context?.activeQuiz = false
        context?.setState(EndedQuizState())
        // Other cleanup logic for ending a quiz
    }

    func setResponseTime(_ time: TimeInterval) {
        responseTime = time
    }

    private func playSound(fileName: String, fileType: String) {
        print("Playing Moderator sfx")
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
                let url = URL(fileURLWithPath: path)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } else {
                print("Sound file not found: \(fileName).\(fileType)")
                // No need to transition to the next state here
            }
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
            // No need to transition to the next state here
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        player.delegate = nil
        audioPlayer = nil
        transitionToNextState()
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
