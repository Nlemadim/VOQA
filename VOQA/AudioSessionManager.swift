//
//  AudioSessionManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import Foundation
import AVFoundation

class AudioSessionManager {
    static func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    static func activateAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(true)
        } catch {
            print("Failed to activate audio session: \(error.localizedDescription)")
        }
    }
}

