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
    @Published var currentQuestionId: UUID? = nil

    private var audioPlayer: AVAudioPlayer?
    var questions: [Question] = []
    private var context: QuizContext?
    var observers: [StateObserver] = []
    private var action: QuestionPlayerAction?

    init(action: QuestionPlayerAction? = nil) {
        self.action = action
        super.init()
    }

    func updateHasNextQuestion() {
        hasMoreQuestions = currentQuestionIndex < questions.count
        let currentQuestionId = questions[currentQuestionIndex].id
        self.currentQuestionId = currentQuestionId
        if let context = context {
            DispatchQueue.main.async {
                context.currentQuestionId = currentQuestionId
                context.currentQuestion = self.questions[self.currentQuestionIndex]
            }
        }

        print("Question Playing ID: \(currentQuestionId)")
        print("Context has captured Question Playing ID: \(String(describing: context?.currentQuestion?.id ?? nil))")
    }

    func pausePlayback() {
        audioPlayer?.pause()
    }

    func playQuestions(_ questions: [Question], in context: QuizContext) {
        print("Question Player Hit")
        self.questions = questions
        self.context = context
        updateHasNextQuestion()
        playQuestion(questions[currentQuestionIndex])
    }

    func handleState(context: QuizContext) {
        if let action = self.action {
            performAction(action, context: context)
        }
    }

    private func performAction(_ action: QuestionPlayerAction, context: QuizContext) {
        switch action {
        case .playNextQuestion:
            guard currentQuestionIndex < questions.count else {
                resetPlayer()
                return
            }
            let question = questions[currentQuestionIndex]
            playQuestion(question)
        }
    }

    private func playQuestion(_ question: Question) {
        isPlayingQuestion = true
        startPlaybackFromBundle(fileName: question.audioUrl)
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
        //context.isListening = true
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
        // Handle state changes if needed
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
