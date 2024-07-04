//
//  SessionAudioPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation
import AVFoundation

enum AudioAction {
    case playCorrectAnswerCallout
    case playWrongAnswerCallout
    case playNoResponseCallout
    case waitingFoprResponse
    case recievedResponse
    case playQuestion(url: String)
    case playAnswer(url: String)
    case playFeedBackMessage(url: String)
    case nextQuestion
    case reviewing
    case pausePlay
    case reset
    
}


class SessionAudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var context: QuizSession
    
    init(context: QuizSession) {
        self.context = context
    }
    
    func handleState(context: QuizSession) {
        context.setState(context.sessionCoordinator)
        context.sessionCoordinator.performAction(.reRouteAndSynchronize, session: context)
    }
    
    func performAudioAction(_ action: AudioAction) {
        switch action {
        case .playCorrectAnswerCallout:
            playCorrectAnswerCallout()
        case .playWrongAnswerCallout:
            playWrongAnswerCallout()
        case .playNoResponseCallout:
            playNoResponseCallout()
        case .waitingFoprResponse:
            playRespondBeep()
        case .recievedResponse:
            playHasRespondedBeep()
        case .nextQuestion:
            playNextQuestionWave()
        case .reviewing:
            playReview()
        case .playQuestion(url: let url):
            playAudioQuestion(question: url)
        case .playAnswer(url: let url):
            playQuestionAnswer(answer: url)
        case .pausePlay:
            pausePlayback()
        case .reset:
            audioPlayer?.stop()
            audioPlayer = nil
        case .playFeedBackMessage(url: let url):
            playFeedbackMessage(messageUrl: url)
        }
    }
    
    private func playAudioQuestion(question url: String) {
        startPlaybackFromBundle(fileName: url)
    }
    
    private func playFeedbackMessage(messageUrl: String) {
        startPlaybackFromBundle(fileName: messageUrl)
    }
    
    private func playQuestionAnswer(answer url: String) {
        startPlaybackFromBundle(fileName: url)
    }
    
    private func playCorrectAnswerCallout() {
        playLocalSFX(fileName: "correctAnswerBell", fileType: "wav")
    }

    private func playWrongAnswerCallout() {
        playLocalSFX(fileName: "wrongAnswerBell", fileType: "wav")
    }

    private func playNoResponseCallout() {
        playLocalSFX(fileName: "errorBell", fileType: "wav")
    }
    
    private func playNextQuestionWave() {
        playLocalSFX(fileName: "NextQuestionWave", fileType: "wav")
    }
    
    private func playReview() {
        playLocalSFX(fileName: "VoqaBgm", fileType: "mp3")
    }
    
    private func playRespondBeep() {
        print("Respond Beep")
        playLocalSFX(fileName: "showResponderBell", fileType: "wav")
    }
    
    private func playHasRespondedBeep() {
        print("Recieved Response Beep")
        playLocalSFX(fileName: "dismissResponderBell", fileType: "wav")
    }
    
   
    
    private func pausePlayback() {
        audioPlayer?.pause()
    }
    
    private func playLocalSFX(fileName: String, fileType: String) {
        print("Playing local sfx")
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            if player == self.audioPlayer {
                if self.context.activeQuiz {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.handleState(context: self.context)
                    }
                }
            } else {
                print("Unknown player finished")
            }
        }
    }
}

