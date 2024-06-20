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
        case stop
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
        case .stop:
            print("Playback protocol state is: \(action)")
            if let audioPlayer = context.audioPlayer {
                DispatchQueue.main.async {
                    audioPlayer.stopAndResetPlayer()
                    audioPlayer.currentQuestionIndex += 1
                }
                print("Simulating waiting for answer protocol")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    print("Simulating continuation protocol")
                    audioPlayer.playCurrentQuestion()
                }
            }
        }
        notifyObservers()
    }
}
