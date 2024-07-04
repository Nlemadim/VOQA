//
//  QuizContextPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/29/24.
//

import Foundation
import AVFoundation

enum AudioAction {
    case playCorrectAnswerCallout
    case playWrongAnswerCallout
    case playNoResponseCallout
    case playMicBeeper(Beeper)
    case playQuestion(url: String)
    case playAnswer(url: String)
    case nextQuestion
    case reviewing
    case pausePlay
    case reset
    
}


class QuizContextPlayer: NSObject, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var context: QuizContext
    
    init(context: QuizContext) {
        self.context = context
    }
    
    func handleState(context: QuizContext) {
        if context.state is QuizPresenter {
            if context.presenter.nowPresentingMic {
                
                context.quizContextPlayer.performAudioAction(.playMicBeeper(.micOn))
                
            }
            
            

        }
        
//        if context.state is FeedbackMessageState {
//            print("ContextPlayer is transferring state back to Feedback Messenger")
//            
//            context.feedbackMessenger.performAction(.proceedWithQuiz, context: context)
//        }
//        
//        if context.state is ReviewState {
//            print("ContextPlayer is transferring state back to Reviewer")
//            
//            context.reviewer.performAction(.reviewing, context: context)
//        }
//        
//        if context.state is QuestionPlayer {
//            print("ContextPlayer is transferring state back to Question Player")
//            
//            context.questionPlayer.performAction(.playNextQuestion, context: context)
//        }
//        
//        if context.state is ListeningState {
//            print("ContextPlayer is transferring state back to Listening State")
//            
//            if context.isListening {
//                context.listener.performAction(.prepareMicrophone, context: context)
//            } else {
//                context.listener.performAction(.proceedWithQuiz, context: context)
//            }
//            
//        }
    }
    
    func performAudioAction(_ action: AudioAction) {
        switch action {
        case .playCorrectAnswerCallout:
            playCorrectAnswerCallout()
        case .playWrongAnswerCallout:
            playWrongAnswerCallout()
        case .playNoResponseCallout:
            playNoResponseCallout()
        case .playMicBeeper(let beeper):
            playMicBeeper(beeper: beeper)
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
        }
    }
    
    private func playAudioQuestion(question url: String) {
        startPlaybackFromBundle(fileName: url)
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
    
    private func playMicBeeper(beeper: Beeper) {
        print("Mic Beeper!")
        switch beeper {
        case .micOn:
            playLocalSFX(fileName: "showResponderBell", fileType: "wav")
        case .micOff:
            print("Mic Closer!")
            playLocalSFX(fileName: "dismissResponderBell", fileType: "wav")
        }
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

