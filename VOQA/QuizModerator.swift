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
    private var action: ModeratorAction?
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
            //Tried Using context.@Published var currentQuestionID. Will invistigate why i cant track the question this way
            let question = context.questionPlayer.questions[context.questionPlayer.currentQuestionIndex]
            validateResponse(context.spokenAnswerOption, question: question)
        }
    }

    func startQuiz() {
        context?.activeQuiz = true
        context?.setState(StartedQuizState())
        // Other initialization logic for starting a quiz
    }
    
    func validateResponse(_ response: String, question: Question) {
        print("Moderator Hit")
        let isQandA = self.isQandA

        DispatchQueue.main.async {
        
            if response.lowercased().isEmptyOrWhiteSpace {
                print("No response!")
                if isQandA {
                    self.playNoResponseCallout()
                } else {
                    self.transitionToNextState()
                }
            } else if response.lowercased() == question.correctOption.lowercased() {
                print("Correct answer!")
                if isQandA {
                    self.playCorrectAnswerCallout()
                } else {
                    self.transitionToNextState()
                }
            } else {
                print("Incorrect answer.")
                if isQandA {
                    self.playWrongAnswerCallout()
                } else {
                    self.transitionToNextState()
                }
            }
        }
    }

    func validateResponse(_ response: String, for questionId: UUID) {
        print("Moderator Hit")
        
        guard let question = context?.questions.first(where: { $0.id == questionId }) else {
            print("Question not found")
            print("\(String(describing: context?.questions.count))")
            print("\(String(describing: context?.currentQuestionId))")
            print("Moderating Question: \(questionId)")
            return
        }

        if response.lowercased().isEmptyOrWhiteSpace {
            if isQandA {
                playNoResponseCallout()
            } else {
                transitionToNextState()
            }
        } else if response.lowercased() == question.correctOption.lowercased() {
            print("Correct answer!")
            if isQandA {
                playCorrectAnswerCallout()
            } else {
                transitionToNextState()
            }
        } else {
            print("Incorrect answer.")
            if isQandA {
                playWrongAnswerCallout()
            } else {
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
        print("Checking question status")
        guard let context = context else { return }
        if context.questionPlayer.hasMoreQuestions {
            
            DispatchQueue.main.async {
                context.hasMoreQuestions = true
                print("Proceeding with quiz")
                context.questionPlayer.currentQuestionIndex += 1
                context.updateQuestionCounter(questionIndex: context.questionPlayer.currentQuestionIndex, count: context.questions.count)
                context.setState(QuestionPlayer(action: .playNextQuestion))
            }
        } else {
            context.hasMoreQuestions = false
            context.setState(ReviewState(action: .reviewing))
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
