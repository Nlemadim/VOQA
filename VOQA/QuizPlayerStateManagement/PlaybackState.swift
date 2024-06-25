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
    }
    
    override func handleState(context: QuizContext) {
        switch action {
        case .start:
            print("Playback started")
        case .pause:
            print("Playback paused")
        case .resume:
            print("Playback resumed")
            print("Playback protocol state is: \(action)")
            if let audioPlayer = context.audioPlayer {
                DispatchQueue.main.async {
                    audioPlayer.stopAndResetPlayer()
                    if audioPlayer.hasNextQuestion {
                        audioPlayer.currentQuestionIndex += 1
                        audioPlayer.playCurrentQuestion()
                    } else {
                        let reviewState = ReviewState(action: .reviewing)
                        reviewState.handleState(context: context)
                    }
                }
            }
        case .pausedForResponse:
            print("Playback protocol state is: \(action)")
            context.setState(ListeningState())
            
        default:
            break
        }
        notifyObservers()
    }
}
