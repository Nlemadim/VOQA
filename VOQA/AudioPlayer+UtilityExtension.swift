//
//  AudioPlayer+UtilityExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import AVFAudio

extension AudioContentPlayer {
    // MARK: - Utility Methods

    internal func getAudioDuration(for audioFile: String) -> TimeInterval? {
        do {
            let player = try AVAudioPlayer(contentsOf: getDocumentDirectoryURL(for: audioFile) ?? URL(fileURLWithPath: ""))
            return player.duration
        } catch {
            print("Could not load file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The audio file duration could not be retrieved.")
            return nil
        }
    }

    internal func startPlaybackFromBundle(fileName: String, fileType: String = "mp3", isFeedback: Bool = false, isBackground: Bool = false, secondaryVolume: Float = 0.3) throws {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category != .playback {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        }

        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.volume = isBackground ? volume / 2 : volume
            player.prepareToPlay()
            player.play()

            if isFeedback {
                feedbackPlayer = player
            } else if isBackground {
                secondaryPlayer = player
                secondaryPlayer?.volume = secondaryVolume
            } else {
                audioPlayer = player
            }

            isPlaying = true
        } else {
            throw AudioPlayerError(title: "File Not Found", message: "The audio file \(fileName) could not be found.", errorType: .fileNotFound)
        }
    }

    internal func getDocumentDirectoryURL(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }

    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            if player == self.audioPlayer {
                self.secondaryPlayer?.stop()
                if self.context.activeQuiz {
                    let playbackState = PlaybackState(action: .pausedForResponse)
                    playbackState.handleState(context: self.context)
                }
            } else if player == self.secondaryPlayer {
                // Handle completion of secondary player if needed
            } else if player == self.feedbackPlayer {
                if self.context.activeQuiz {
                    let playbackState = PlaybackState(action: .resume)
                    playbackState.handleState(context: self.context)
                }
            } else if player == self.audioPlayer && !self.context.activeQuiz {
                let reviewState = ReviewState(action: .doneReviewing)
                reviewState.handleState(context: self.context)
            } else {
                print("Unknown player finished")
            }
        }
    }
}
