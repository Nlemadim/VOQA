//
//  AudioPlayer+FeedbackAndReviewExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

extension AudioContentPlayer {
    // MARK: - Feedback and Review
    internal func playFeedbackAudio(type: FeedbackMessageState.FeedbackType, audioFile: String) {
        do {
            try startPlaybackFromBundle(fileName: audioFile.deletingPathExtension, fileType: audioFile.pathExtension, isFeedback: true)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The feedback audio file could not be found.")
        }
    }

    internal func playReviewAudio(_ audioFiles: [String]) {
        playMultipleAudioFiles(audioFiles, currentIndex: 0)
    }
}
