//
//  QuizOrchestra.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation

class QuizOrchestra: BgmPlayerDelegate {
    var commandCenter: CommandCenter
    var session: QuizSession?

    init(commandCenter: CommandCenter) {
        self.commandCenter = commandCenter
    }

    // Orchestrate the start of the quiz, playing background music and voice intro
    func startFlow() {
        print("Orchestra: Starting quiz flow.")

        // Step 1: Start the background music
        commandCenter.startBackgroundMusic()
        session?.isNowPlaying = true

        // Step 2: After a delay, play the voice intro
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            self.playHostIntro()
        }
    }

    // Play the voice intro
    private func playHostIntro() {
        print("Orchestra: Playing voice intro.")
        commandCenter.playHostIntro()
    }
    
    func bgmPlayerDidFinishPlaying(_ player: BgmPlayer) {
        print("Orchestra: Background music finished. Moving to next action.")
        session?.isNowPlaying = false
    }
}
