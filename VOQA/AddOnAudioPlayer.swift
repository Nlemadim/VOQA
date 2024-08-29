//
//  AddOnAudioPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation
import AVFoundation

final class AudioCacheManager {
    static let shared = AudioCacheManager()
    private init() {}

    private var cache = [URL: Data]() // Dictionary to store cached audio data

    func hasAudioInCache(url: URL) -> Data? {
        return cache[url]
    }

    func cacheAudioData(url: URL, data: Data) {
        cache[url] = data
    }
}


final class AddOnAudioPlayer: NSObject {
    private var player: AVAudioPlayer?
    private var fadeOutTimer: Timer?

    func playAudio(from url: URL, completion: @escaping (Bool) -> Void) {
        // Check if the audio data is cached
        if let cachedData = AudioCacheManager.shared.hasAudioInCache(url: url) {
            playAudioData(cachedData, completion: completion)
            return
        }

        // Download audio data if not cached
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            // Cache the audio data
            AudioCacheManager.shared.cacheAudioData(url: url, data: data)

            // Play the audio data
            self.playAudioData(data, completion: completion)
        }.resume()
    }

    private func playAudioData(_ data: Data, completion: @escaping (Bool) -> Void) {
        do {
            player = try AVAudioPlayer(data: data)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()

            // Set a timer to fade out the audio after 15 seconds if longer
            if player?.duration ?? 0 > 15 {
                fadeOutTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { [weak self] _ in
                    self?.fadeOutAudio()
                }
            }

            DispatchQueue.main.async {
                completion(true)
            }
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }

    private func fadeOutAudio() {
        guard let player = player, player.isPlaying else { return }

        player.setVolume(0, fadeDuration: 2.0) // Fade out over 2 seconds
        player.stop()
        fadeOutTimer?.invalidate()
    }

    func stopAudio() {
        player?.stop()
        fadeOutTimer?.invalidate()
    }
}

extension AddOnAudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle audio finish playing logic here
    }
}
