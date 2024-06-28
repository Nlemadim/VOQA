//
//  PlaybackState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import Foundation

/// State representing the playback-related state of the quiz.
class PlaybackState: BaseState {
    enum PlaybackAction {
        case start
        case pause
        case resume
        case pausedForResponse
        case intermissionAndReview
        case pausedForAd
    }
    
    var action: PlaybackAction
    
    init(action: PlaybackAction) {
        self.action = action
        print("PlaybackState initialized")
    }
    
    override func handleState(context: QuizContext) {
        switch action {
        case .start:
            print("Playback started")
        case .pause:
            print("Playback paused")
        case .resume:
            handleResume(context: context)
        case .pausedForResponse:
            handlePausedForResponse(context: context)
        default:
            break
        }
        notifyObservers()
    }
    
    private func handleResume(context: QuizContext) {
        print("Playback resumed")
//        if let audioPlayer = context.audioPlayer {
//            DispatchQueue.main.async {
//                audioPlayer.stopAndResetPlayer()
//                audioPlayer.updateHasNextQuestion()
//                print("Audio player has more questions: \(audioPlayer.hasNextQuestion)")
//               
//                if audioPlayer.hasNextQuestion {
//                    audioPlayer.currentQuestionIndex += 1
//                    audioPlayer.playCurrentQuestion()
//                } else {
//                    let reviewState = ReviewState(action: .reviewing)
//                    reviewState.handleState(context: context)
//                }
//            }
//        }
    }
    
    private func handlePausedForResponse(context: QuizContext) {
        print("Playback protocol state is: \(action)")
//        if let audioPlayer = context.audioPlayer {
//            audioPlayer.updateHasNextQuestion()
//        }
        
        context.prepareMicrophone()
        
        // Add a delay before setting to ListeningState
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            context.setState(ListeningState())
        }
    }
}

