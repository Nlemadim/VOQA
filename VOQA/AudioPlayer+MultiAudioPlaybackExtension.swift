//
//  AudioPlayer+MultiAudioPlaybackExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

extension AudioContentPlayer {
    // MARK: - Multi Audio Playback
    
    internal func playMultiAudioFiles(mainFile: String, bgmFile: String) {
        shouldPlay = true
        do {
            try startPlaybackFromBundle(fileName: mainFile.deletingPathExtension, fileType: mainFile.pathExtension)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if self.shouldPlay {
                    do {
                        try self.startPlaybackFromBundle(fileName: bgmFile.deletingPathExtension, fileType: bgmFile.pathExtension, isBackground: true)
                    } catch {
                        print("Could not load background music file: \(error.localizedDescription)")
                        self.handleError(.fileNotFound, message: "The background music file could not be found.")
                    }
                }
            }
        } catch {
            print("Could not load main file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The main audio file could not be found.")
        }
    }

    internal func playBackgroundMusic(_ bgmFile: String, mainFile: String) {
        do {
            try startPlaybackFromBundle(fileName: bgmFile.deletingPathExtension, fileType: bgmFile.pathExtension, isBackground: true)
            try startPlaybackFromBundle(fileName: mainFile.deletingPathExtension, fileType: mainFile.pathExtension)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The background or main audio file could not be found.")
        }
    }

    internal func playMultipleAudioFiles(_ audioFiles: [String], currentIndex: Int, secondaryVolume: Float = 1.0) {
        guard currentIndex < audioFiles.count else {
            return
        }

        let audioFile = audioFiles[currentIndex]

        do {
            try startPlaybackFromBundle(fileName: audioFile.deletingPathExtension, fileType: audioFile.pathExtension, secondaryVolume: secondaryVolume)
            DispatchQueue.main.asyncAfter(deadline: .now() + audioPlayer!.duration) {
                self.playMultipleAudioFiles(audioFiles, currentIndex: currentIndex + 1, secondaryVolume: secondaryVolume)
                print(self.currentPlaybackPower)
            }
        } catch {
            print("Could not load file: \(error.localizedDescription)")
        }
    }
    
    // Method 1: correctAnswerCallout
    internal func correctAnswerCallout(calloutFile: String, bgmFile: String) {
        shouldPlay = true
        do {
            // Play background music
            try startPlaybackFromBundle(fileName: bgmFile.deletingPathExtension, fileType: bgmFile.pathExtension, isBackground: true)
            // Play callout
            try startPlaybackFromBundle(fileName: calloutFile.deletingPathExtension, fileType: calloutFile.pathExtension)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The audio file could not be found.")
        }
    }
    
    // Method 2: intermissionAndReview
    internal func intermissionAndReview(endMessageFile: String, intermissionBgmFile: String, reviewMessageFile: String) {
        shouldPlay = true
        do {
            // Play end message
            try startPlaybackFromBundle(fileName: endMessageFile.deletingPathExtension, fileType: endMessageFile.pathExtension)
            
            // Play intermission background music
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if self.shouldPlay {
                    do {
                        try self.startPlaybackFromBundle(fileName: intermissionBgmFile.deletingPathExtension, fileType: intermissionBgmFile.pathExtension, isBackground: true)
                    } catch {
                        print("Could not load intermission background music file: \(error.localizedDescription)")
                        self.handleError(.fileNotFound, message: "The intermission background music file could not be found.")
                    }
                }
            }

            // Play review message after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if self.shouldPlay {
                    do {
                        try self.startPlaybackFromBundle(fileName: reviewMessageFile.deletingPathExtension, fileType: reviewMessageFile.pathExtension)
                    } catch {
                        print("Could not load review message file: \(error.localizedDescription)")
                        self.handleError(.fileNotFound, message: "The review message file could not be found.")
                    }
                }
            }
        } catch {
            print("Could not load file: \(error.localizedDescription)")
            handleError(.fileNotFound, message: "The audio file could not be found.")
        }
    }
}
