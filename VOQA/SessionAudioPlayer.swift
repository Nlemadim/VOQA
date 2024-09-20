//
//  SessionAudioPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//


import Foundation
import AVFoundation


class SessionAudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var audioPlayerManager: AudioPlayerManager
    private weak var context: QuizSession?
    private var actionQueue: [AudioAction] = []
    private var isProcessingAction = false
    private var lastAction: AudioAction?
    private var audioFileSorter: AudioFileSorter

    init(context: QuizSession?, audioFileSorter: AudioFileSorter, action: AudioAction? = nil) {
        self.context = context
        self.audioFileSorter = audioFileSorter
        self.audioPlayerManager = AudioPlayerManager()
        super.init()
        self.audioPlayerManager.delegate = self
        AudioSessionManager.setupAudioSession()
        if let initialAction = action {
            enqueueAction(initialAction)
        }
    }

    func setContext(_ context: QuizSession) {
        self.context = context
    }

    private func enqueueAction(_ action: AudioAction) {
        actionQueue.append(action)
        processNextAction()
    }

    func performAudioAction(_ action: AudioAction) {
        enqueueAction(action)
    }
    
    func pausePlayer() {
        self.audioPlayerManager.pausePlayback()
    }
    
    func stopPlayback() {
        self.audioPlayerManager.stopPlayback()
    }

    private func processNextAction() {
        guard !isProcessingAction, !actionQueue.isEmpty else {
            return
        }
        
        isProcessingAction = true
        let nextAction = actionQueue.removeFirst()
        executeAudioAction(nextAction)
    }

    private func executeAudioAction(_ action: AudioAction) {
        lastAction = action
        
        if let context = context {
            context.isNowPlaying = true
        }
        
        if let audioUrl = audioFileSorter.getAudioFile(for: action) {
            audioPlayerManager.playAudioFromURL(url: audioUrl)
        } else {
            completeCurrentAction()
        }
    }

    private func completeCurrentAction() {
        isProcessingAction = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.processNextAction()
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        handleAudioFinish()
        
        if let context = context {
            context.isNowPlaying = false
        }
        
    }

    private func handleAudioFinish() {
        guard let context = context else {
            completeCurrentAction()
            return
        }
        
        print("Audio player finished playing on state: \(context.state)")
        
        context.isNowPlaying = false
        
        if context.state is QuizSession {
            if lastAction == .playAnswer(url: context.currentQuestion?.correctionAudioURL ?? "") {
                context.resumeQuiz()
            }
            
            if lastAction == .playCorrectAnswerCallout {
                context.resumeQuiz()
            }
        }
        
        if context.state is QuestionPlayer {
            if lastAction == .playQuestionAudioUrl(url: context.currentQuestion?.questionScriptAudioURL ?? "") {
                context.awaitResponse()
            }
        }
        
        if context.state is ReviewsManager {
            if lastAction == .reviewing {
                context.prepareToEndSession()
                enqueueAction(.reset)
            }
        }
        
        completeCurrentAction()
    }
}




//class SessionAudioPlayer: NSObject, AVAudioPlayerDelegate {
//    private var audioPlayerManager: AudioPlayerManager
//    private var context: QuizSession?
//    private var actionQueue: [AudioAction] = []
//    private var isProcessingAction = false
//    private var lastAction: AudioAction?
//
//    init(context: QuizSession?, action: AudioAction? = nil) {
//        self.context = context
//        self.audioPlayerManager = AudioPlayerManager()
//        super.init()
//        self.audioPlayerManager.delegate = self
//        AudioSessionManager.setupAudioSession()
//        if let initialAction = action {
//            enqueueAction(initialAction)
//        }
//    }
//
//    func setContext(_ context: QuizSession) {
//        self.context = context
//    }
//
//    private func enqueueAction(_ action: AudioAction) {
//        actionQueue.append(action)
//        processNextAction()
//    }
//
//    func performAudioAction(_ action: AudioAction) {
//        enqueueAction(action)
//    }
//
//    private func processNextAction() {
//        guard !isProcessingAction, !actionQueue.isEmpty else {
//            return
//        }
//        isProcessingAction = true
//        let nextAction = actionQueue.removeFirst()
//        executeAudioAction(nextAction)
//    }
//
//    private func executeAudioAction(_ action: AudioAction) {
//        lastAction = action
//        switch action {
//        case .playCorrectAnswerCallout:
//            audioPlayerManager.playAudio(fileName: "correctAnswerBell", fileType: "wav")
//
//        case .playWrongAnswerCallout:
//            audioPlayerManager.playAudio(fileName: "wrongAnswerBell", fileType: "wav")
//
//        case .playNoResponseCallout:
//            audioPlayerManager.playAudio(fileName: "errorBell", fileType: "wav")
//
//        case .waitingForResponse:
//            audioPlayerManager.playAudio(fileName: "showResponderBell", fileType: "wav")
//
//        case .receivedResponse:
//            audioPlayerManager.playAudio(fileName: "dismissResponderBell", fileType: "wav")
//
//        case .nextQuestion:
//            audioPlayerManager.playAudio(fileName: "NextQuestionWave", fileType: "wav")
//
//        case .reviewing:
//            audioPlayerManager.playAudio(fileName: "TheSeeker-VoFx", fileType: "mp3")
//
//        case .playQuestionAudioUrl(let url), .playAnswer(let url), .playFeedbackMessage(let url):
//            audioPlayerManager.playAudioFromURL(urlString: url)
//
//        case .pausePlay:
//            audioPlayerManager.pausePlayback()
//            completeCurrentAction()
//
//        case .reset:
//            audioPlayerManager.stopPlayback()
//            completeCurrentAction()
//        }
//    }
//
//    private func completeCurrentAction() {
//        isProcessingAction = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust delay as necessary
//            self.processNextAction()
//        }
//    }
//
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        handleAudioFinish()
//        print("Handler Called")
//    }
//
//    private func handleAudioFinish() {
//        print("Handle finish called")
//        guard let context = context else {
//            print("No context available")
//            completeCurrentAction()
//            return
//        }
//        
//        if context.state is QuestionPlayer {
//            if lastAction != .waitingForResponse {
//                print("Current state: \(context.state)")
//                context.beepAwaitingResponse()
//            }
//        } else if context.state is ReviewsManager {
//            context.prepareToEndSession()
//            enqueueAction(.reset)
//        }
//        completeCurrentAction()
//        print("Audio player finished playing")
//    }
//}
//

