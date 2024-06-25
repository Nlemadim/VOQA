//
//  AudioPlayer+ErrorHandlingExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

extension AudioContentPlayer {
    // MARK: - Error Handling
    internal func handleError(_ errorType: AudioPlayerErrorType, message: String) {
        let error = AudioPlayerError(title: "Playback Error", message: message, errorType: errorType)
        DispatchQueue.main.async {
            self.appError = error
        }
    }
}

