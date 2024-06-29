//
//  QuestionPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/26/24.
//

import Foundation
import AVFoundation
import Combine

class QuestionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, StateObserver, QuizState {
    
    enum QuestionPlayerAction {
        case playNextQuestion
    }

    @Published var isPlayingQuestion: Bool = false
    @Published var hasMoreQuestions: Bool = false
    @Published var currentQuestionIndex: Int = 0
    @Published var currentQuestionId: UUID?

    private var audioPlayer: AVAudioPlayer?
    var questions: [Question] = []
    var context: QuizContext?
    var observers: [StateObserver] = []
    private var action: QuestionPlayerAction?

    init(action: QuestionPlayerAction? = nil) {
        self.action = action
        super.init()
    }
    
    func handleState(context: QuizContext) {
        print("QuestionPlayer handleState called")
        if let action = self.action {
            performAction(action, context: context)
        }
    }

    private func updateHasNextQuestion() {
        hasMoreQuestions = currentQuestionIndex < questions.count - 1
        if hasMoreQuestions {
            let nextQuestionId = questions[currentQuestionIndex + 1].id
            context?.updateCurrentQuestionId(nextQuestionId)
        }
        print("Updated hasMoreQuestions: \(hasMoreQuestions), next question ID: \(String(describing: context?.currentQuestionId))")
    }


    func pausePlayback() {
        audioPlayer?.pause()
    }

    func playQuestions(_ questions: [Question], in context: QuizContext) {
        self.questions = questions
        self.context = context
        updateHasNextQuestion()
        playQuestion(questions[currentQuestionIndex])
    }
    
    private func playQuestion(_ question: Question) {
        isPlayingQuestion = true
        currentQuestionId = question.id
        context?.updateCurrentQuestionId(question.id)
        print("Playing question with ID: \(question.id)")
        startPlaybackFromBundle(fileName: question.audioUrl)
    }

   

    func performAction(_ action: QuestionPlayerAction, context: QuizContext) {
        print("QuestionPlayer performAction called with action: \(action)")
        print("Current Question Index: \(currentQuestionIndex)")
        print("Total Questions: \(questions.count)")
        
        switch action {
        case .playNextQuestion:
            guard currentQuestionIndex < questions.count else {
                print("No more questions to play, resetting player")
                resetPlayer()
                return
            }
            
            let question = questions[currentQuestionIndex]
            print("Playing question at index \(currentQuestionIndex): \(question)")
            playQuestion(question)
        }
    }

    
    internal func startPlaybackFromBundle(fileName: String, fileType: String = "mp3") {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.category != .playback {
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
            }

            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
                let url = URL(fileURLWithPath: path)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } else {
                print("Audio file not found: \(fileName).\(fileType)")
            }
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    private func proceedToNextQuestion() {
        isPlayingQuestion = false
        updateHasNextQuestion()

        if hasMoreQuestions {
            transitionToListeningState()
        } else {
            resetPlayer()
        }
    }

    private func resetPlayer() {
        audioPlayer = nil
        currentQuestionIndex = 0
        //UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
        hasMoreQuestions = false
    }

    private func transitionToListeningState() {
        guard let context = context else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            context.setState(ListeningState(action: .prepareToTranscribe))
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlayingQuestion = false
            if player == self.audioPlayer {
                if self.context?.activeQuiz == true {
                    self.proceedToNextQuestion()
                }
            } else {
                print("Unknown player finished")
            }
        }
    }
    
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
    }
    
    // StateObserver
    func stateDidChange(to newState: QuizState) {
        print("Question Player state did change to \(type(of: newState))")
        // Handle state changes if needed
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


/**
 fix: Ensure QuestionPlayer performs action immediately after state transition to prevent unintended state changes

 ## Bug Description
 - The application was experiencing unintended state transitions where `ListeningState` was being triggered unexpectedly after transitioning to `QuestionPlayer`.
 - This was likely due to `QuestionPlayer` initializing without performing an action, causing the `audioPlayerDidFinishPlaying` method to be invoked unexpectedly when no sound was played.

 ## Fix Description
 - Added an explicit call to `performAction(.playNextQuestion, context: context)` immediately after setting the state to `QuestionPlayer` in `transitionToNextState` method of `QuizModerator`.
 - This ensures that `QuestionPlayer` starts playing the next question immediately, preventing any unintended state changes.

 ## Established Flow (as of this commit)
 1. **Transition from `QuizModerator` to `QuestionPlayer`:**
    - `QuizModerator` transitions to `QuestionPlayer` and performs the `playNextQuestion` action.
    - The `performAction` method in `QuestionPlayer` verifies the `currentQuestionIndex`, updates the `currentQuestionId`, and starts playing the question.

 2. **Handling `audioPlayerDidFinishPlaying`:**
    - When a question finishes playing, `audioPlayerDidFinishPlaying` is invoked.
    - This method triggers `proceedToNextQuestion`, which checks if there are more questions.
    - If more questions are available, it transitions to `ListeningState`; otherwise, it resets the player.

 3. **Flow Control:**
    - The explicit call to `performAction(.playNextQuestion, context: context)` ensures `QuestionPlayer` performs the intended action immediately after the state transition.
    - This prevents the `audioPlayerDidFinishPlaying` method from being invoked unexpectedly due to the absence of sound playback.

 By following this updated flow, the state transitions and actions are now correctly managed, ensuring the quiz application works smoothly without unintended state changes.


 
 */
