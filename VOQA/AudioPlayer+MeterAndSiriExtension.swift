//
//  AudioPlayer+MeterAndSiriExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import AVFAudio

extension AudioContentPlayer {
    // MARK: - Meter Updates and Siri Playback
    internal func updateMeters() {
        audioPlayer?.updateMeters()
        if let power = audioPlayer?.averagePower(forChannel: 0) {
            DispatchQueue.main.async {
                self.currentPlaybackPower = power
            }
        }
    }

    internal func playWithSiri(_ script: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: script)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        speechSynthesizer.speak(speechUtterance)
    }
}
