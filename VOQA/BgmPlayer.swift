//
//  BgmPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import AVFoundation
import Foundation

class BgmPlayer: NSObject, AVAudioPlayerDelegate {
    // MARK: - Properties
    var audioPlayer: AVAudioPlayer?
    private var audioCache: [String: Data] = [:]  // Caches the audio files using String URLs
    private var audioUrls: [String]
    private var currentAudioUrl: String?
    
    weak var delegate: BgmPlayerDelegate?

    // MARK: - Initializer
    init(audioUrls: [String]) {
        self.audioUrls = audioUrls
        super.init()  // Call to NSObject init
        selectRandomAudioUrl()
        AudioSessionManager.setupAudioSession()  // Ensure audio session is set up on initialization
    }

    // MARK: - Helper Methods
    
    // Select a random audio URL from the array (if available)
    private func selectRandomAudioUrl() {
        guard !audioUrls.isEmpty else {
            currentAudioUrl = nil
            return
        }
        currentAudioUrl = audioUrls.randomElement()
    }

    // Plays the selected background music (if available)
    func playStartUpMusic() {
        guard let urlString = currentAudioUrl else {
            print("No background music available.")
            return
        }

        // Activate audio session before playing
        AudioSessionManager.activateAudioSession()

        // Check if audio is already cached
        if let cachedData = audioCache[urlString] {
            playAudio(from: cachedData)
        } else {
            // Convert string to URL
            guard let url = URL(string: urlString) else {
                print("Invalid URL string: \(urlString)")
                return
            }

            // Download and cache the audio if not already cached
            downloadAudio(from: url) { [weak self] data in
                guard let self = self else { return }
                self.audioCache[urlString] = data
                self.playAudio(from: data)
            }
        }

        // Start loud and fade to 30% volume after 5 seconds
        adjustVolume(to: 1.0, fadeDuration: 0.0)  // Start loud
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.adjustVolume(to: 0.3, fadeDuration: 1.0)  // Fade to 30% after 5 seconds
            
            // Call the fadeOutIntro to gradually fade out the music over 30 seconds
            self?.fadeOutIntro()
        }
    }

    // Fade out the background music over 30 seconds and stop it at the end
    func fadeOutIntro() {
        let fadeDuration: TimeInterval = 55.0
        let fadeSteps = 300  // Increasing the number of steps for a smoother fade-out
        let fadeInterval: TimeInterval = fadeDuration / TimeInterval(fadeSteps)
        let fadeAmount: Float = 0.003  // Smaller amount for each step (this can be adjusted based on testing)

        // Perform volume fade out in steps
        for i in 1...fadeSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeInterval * TimeInterval(i)) { [weak self] in
                guard let self = self else { return }
                let currentVolume = self.audioPlayer?.volume ?? 0
                let newVolume = max(0, currentVolume - fadeAmount)  // Gradually reduce volume

                // Adjust volume for this step
                self.adjustVolume(to: newVolume, fadeDuration: 0.0)

                // Stop music when volume reaches zero
                if newVolume <= 0 {
                    self.stopBackgroundMusic()
                }
            }
        }
    }

    // Downloads audio from a URL asynchronously
    private func downloadAudio(from url: URL, completion: @escaping (Data) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to download audio from \(url): \(String(describing: error?.localizedDescription))")
                return
            }
            completion(data)
        }
        task.resume()
    }

    // Plays the audio from the provided data
    private func playAudio(from data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self  // Set self as delegate to handle lifecycle events
            audioPlayer?.numberOfLoops = -1  // Loop indefinitely
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    // Adjust volume to the specified level over a given duration
    func adjustVolume(to volume: Float, fadeDuration: TimeInterval) {
        audioPlayer?.setVolume(volume, fadeDuration: fadeDuration)
    }

    // Stops the currently playing audio
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }

    // Pauses the currently playing audio
    func pauseBackgroundMusic() {
        audioPlayer?.pause()
    }

    // Resumes the currently playing audio
    func resumeBackgroundMusic() {
        audioPlayer?.play()
    }

    // Clears the cached audio files
    func clearCache() {
        audioCache.removeAll()
    }

    // MARK: - AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Background music finished playing.")
        delegate?.bgmPlayerDidFinishPlaying(self)
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio player decode error occurred: \(String(describing: error?.localizedDescription))")
    }
}
