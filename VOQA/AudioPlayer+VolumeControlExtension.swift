//
//  AudioPlayer+VolumeControlExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

extension AudioContentPlayer {
    // MARK: - Volume Control
    internal func setVolume(_ volume: Float) {
        self.volume = volume
        audioPlayer?.volume = volume
        secondaryPlayer?.volume = volume / 2
        feedbackPlayer?.volume = volume
    }
}
