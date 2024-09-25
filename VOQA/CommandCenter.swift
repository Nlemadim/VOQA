//
//  CommandCenter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation

class CommandCenter {
    var session: QuizSession?
    
    init(session: QuizSession?) {
        self.session = session
    }
    
    // Start background music using the BgmPlayer
    func startBackgroundMusic() {
        guard let session = session else { return }
        print("Command Center: Starting background music.")
        session.bgmPlayer.playStartUpMusic()
    }
    
    func playHostIntro() {
        guard let session = session else { return }
        print("Command Center: Playing host intro.")
        let introAction = AudioAction.playHostIntro
        session.sessionAudioPlayer.performAudioAction(introAction)
    }
}


