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
    private var context: QuizSession?
    private var actionQueue: [AudioAction] = []
    private var isProcessingAction = false
    private var lastAction: AudioAction?

    init(context: QuizSession?, action: AudioAction? = nil) {
        self.context = context
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
        switch action {
        case .playCorrectAnswerCallout:
            audioPlayerManager.playAudio(fileName: "correctAnswerBell", fileType: "wav")

        case .playWrongAnswerCallout:
            audioPlayerManager.playAudio(fileName: "wrongAnswerBell", fileType: "wav")

        case .playNoResponseCallout:
            audioPlayerManager.playAudio(fileName: "errorBell", fileType: "wav")

        case .waitingForResponse:
            audioPlayerManager.playAudio(fileName: "showResponderBell", fileType: "wav")

        case .receivedResponse:
            audioPlayerManager.playAudio(fileName: "dismissResponderBell", fileType: "wav")

        case .nextQuestion:
            audioPlayerManager.playAudio(fileName: "NextQuestionWave", fileType: "wav")

        case .reviewing:
            audioPlayerManager.playAudio(fileName: "TheSeeker-VoFx", fileType: "mp3")

        case .playQuestionAudioUrl(let url), .playAnswer(let url), .playFeedbackMessage(let url):
            audioPlayerManager.playAudioFromURL(urlString: url)

        case .pausePlay:
            audioPlayerManager.pausePlayback()
            completeCurrentAction()

        case .reset:
            audioPlayerManager.stopPlayback()
            completeCurrentAction()
        }
    }

    private func completeCurrentAction() {
        isProcessingAction = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust delay as necessary
            self.processNextAction()
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        handleAudioFinish()
        print("Handler Called")
    }

    private func handleAudioFinish() {
        print("Handle finish called")
        guard let context = context else {
            print("No context available")
            completeCurrentAction()
            return
        }
        
        if context.state is QuestionPlayer {
            if lastAction != .waitingForResponse {
                print("Current state: \(context.state)")
                context.beepAwaitingResponse()
            }
        } else if context.state is ReviewsManager {
            context.prepareToEndSession()
            enqueueAction(.reset)
        }
        completeCurrentAction()
        print("Audio player finished playing")
    }
}



//import Foundation
//import AVFoundation
//
//enum AudioAction {
//    case playCorrectAnswerCallout
//    case playWrongAnswerCallout
//    case playNoResponseCallout
//    case waitingFoprResponse
//    case recievedResponse
//    case playQuestionAudioUrl(url: String)
//    case playAnswer(url: String)
//    case playFeedBackMessage(url: String)
//    case nextQuestion
//    case reviewing
//    case pausePlay
//    case reset
//}
//
//
//class SessionAudioPlayer: NSObject, AVAudioPlayerDelegate {
//    
//    var audioPlayer: AVAudioPlayer?
//    var questionPlayer: AVAudioPlayer?
//    var validationPlayer: AVAudioPlayer?
//    var reviewPlayer: AVAudioPlayer?
//    var hasPlayedWaitingBell: Bool = false
//    var context: QuizSession
//    
//    init(context: QuizSession) {
//        self.context = context
//    }
//    
//    func handleState(context: QuizSession) {
//        //context.sessionCoordinator.performAction(.reRouteAndSynchronize, session: context)
//    }
//    
//    func performAudioAction(_ action: AudioAction) {
//        switch action {
//        case .playCorrectAnswerCallout:
//            playCorrectAnswerCallout()
//            
//        case .playWrongAnswerCallout:
//            playWrongAnswerCallout()
//            
//        case .playNoResponseCallout:
//            playNoResponseCallout()
//            
//        case .waitingFoprResponse:
//            playRespondBeep()
//            
//        case .recievedResponse:
//            playHasRespondedBeep()
//            
//        case .nextQuestion:
//            playNextQuestionWave()
//            
//        case .reviewing:
//            playReview()
//            
//        case .playQuestionAudioUrl(url: let url):
//            playAudioQuestion(audio: url)
//            
//        case .playAnswer(url: let url):
//            playQuestionAnswer(answer: url)
//            
//        case .pausePlay:
//            pausePlayback()
//            
//        case .reset:
//            audioPlayer?.stop()
//            audioPlayer = nil
//            
//        case .playFeedBackMessage(url: let url):
//            playFeedbackMessage(messageUrl: url)
//        }
//    }
//    
//    private func playAudioQuestion(audio url: String) {
//        startQuestionPlaybackFromBundle(fileName: url)
//    }
//    
//    private func playFeedbackMessage(messageUrl: String) {
//        startPlaybackFromBundle(fileName: messageUrl)
//    }
//    
//    private func playQuestionAnswer(answer url: String) {
//        startQuestionPlaybackFromBundle(fileName: url)
//    }
//    
//    private func playCorrectAnswerCallout() {
//        playValidationLocalSFX(fileName: "correctAnswerBell", fileType: "wav")
//    }
//
//    private func playWrongAnswerCallout() {
//        playValidationLocalSFX(fileName: "wrongAnswerBell", fileType: "wav")
//    }
//
//    private func playNoResponseCallout() {
//        playValidationLocalSFX(fileName: "errorBell", fileType: "wav")
//    }
//    
//    private func playNextQuestionWave() {
//        playLocalSFX(fileName: "NextQuestionWave", fileType: "wav")
//    }
//    
//    private func playReview() {
//        playReviewLocalSFX(fileName: "TheSeeker-VoFx", fileType: "mp3")
//    }
//    
//    private func playRespondBeep() {
//        print("Respond Beep")
//        playLocalSFX(fileName: "showResponderBell", fileType: "wav")
//    }
//    
//    private func playHasRespondedBeep() {
//        print("Recieved Response Beep")
//        playLocalSFX(fileName: "dismissResponderBell", fileType: "wav")
//    }
//    
//    private func pausePlayback() {
//        audioPlayer?.pause()
//    }
//    
//    private func playLocalSFX(fileName: String, fileType: String) {
//        print("Playing local sfx")
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.playback, mode: .default)
//            try audioSession.setActive(true)
//            
//            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//                let url = URL(fileURLWithPath: path)
//                audioPlayer = try AVAudioPlayer(contentsOf: url)
//                audioPlayer?.delegate = self
//                audioPlayer?.play()
//            } else {
//                print("Sound file not found: \(fileName).\(fileType)")
//                // No need to transition to the next state here
//            }
//        } catch {
//            print("Failed to play sound: \(error.localizedDescription)")
//            // No need to transition to the next state here
//        }
//    }
//    
//    private func playValidationLocalSFX(fileName: String, fileType: String) {
//        print("Playing local sfx")
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.playback, mode: .default)
//            try audioSession.setActive(true)
//            
//            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//                let url = URL(fileURLWithPath: path)
//                validationPlayer = try AVAudioPlayer(contentsOf: url)
//                validationPlayer?.delegate = self
//                validationPlayer?.play()
//            } else {
//                print("Sound file not found: \(fileName).\(fileType)")
//                // No need to transition to the next state here
//            }
//        } catch {
//            print("Failed to play sound: \(error.localizedDescription)")
//            // No need to transition to the next state here
//        }
//    }
//    
//    private func playReviewLocalSFX(fileName: String, fileType: String) {
//        print("Playing Review local sfx")
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.playback, mode: .default)
//            try audioSession.setActive(true)
//            
//            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//                let url = URL(fileURLWithPath: path)
//                reviewPlayer = try AVAudioPlayer(contentsOf: url)
//                reviewPlayer?.delegate = self
//                reviewPlayer?.play()
//            } else {
//                print("Sound file not found: \(fileName).\(fileType)")
//                // No need to transition to the next state here
//            }
//        } catch {
//            print("Failed to play sound: \(error.localizedDescription)")
//            // No need to transition to the next state here
//        }
//    }
//    
//    internal func startPlaybackFromBundle(fileName: String, fileType: String = "mp3") {
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            if audioSession.category != .playback {
//                try audioSession.setCategory(.playback, mode: .default)
//                try audioSession.setActive(true)
//            }
//
//            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//                let url = URL(fileURLWithPath: path)
//                audioPlayer = try AVAudioPlayer(contentsOf: url)
//                audioPlayer?.delegate = self
//                audioPlayer?.play()
//            } else {
//                print("Audio file not found: \(fileName).\(fileType)")
//            }
//        } catch {
//            print("Failed to play audio: \(error.localizedDescription)")
//        }
//    }
//    
//    internal func playValidationFeedback(fileName: String, fileType: String = "mp3") {
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            if audioSession.category != .playback {
//                try audioSession.setCategory(.playback, mode: .default)
//                try audioSession.setActive(true)
//            }
//
//            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//                let url = URL(fileURLWithPath: path)
//                validationPlayer = try AVAudioPlayer(contentsOf: url)
//                validationPlayer?.delegate = self
//                validationPlayer?.play()
//            } else {
//                print("Audio file not found: \(fileName).\(fileType)")
//            }
//        } catch {
//            print("Failed to play audio: \(error.localizedDescription)")
//        }
//    }
//    
//    internal func startQuestionPlaybackFromBundle(fileName: String, fileType: String = "mp3") {
//        print("Calling Audio Session Question Player")
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            if audioSession.category != .playback {
//                try audioSession.setCategory(.playback, mode: .default)
//                try audioSession.setActive(true)
//            }
//
//            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
//                let url = URL(fileURLWithPath: path)
//                questionPlayer = try AVAudioPlayer(contentsOf: url)
//                questionPlayer?.delegate = self
//                questionPlayer?.play()
//            } else {
//                print("Audio file not found: \(fileName).\(fileType)")
//            }
//        } catch {
//            print("Failed to play audio: \(error.localizedDescription)")
//        }
//    }
//    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        DispatchQueue.main.async {
//            if player == self.questionPlayer {
//                print("Question Player finished Playing")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.context.beepAwaitingResponse()
//                }
//            }
//            
//            if player == self.reviewPlayer {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.context.prepareToEndSession()
//                }
//            }
//            
//            if player == self.audioPlayer {
//                print("Audio player finished playing")
//            }
//        }
//    }
//}
//
