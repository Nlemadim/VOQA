//
//  AudioPlayerManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import Foundation
import AVFoundation


class AudioPlayerManager: NSObject {
    var player: AVAudioPlayer?
    weak var delegate: AVAudioPlayerDelegate?

    func playAudio(fileName: String, fileType: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
            print("Sound file not found: \(fileName).\(fileType)")
            return
        }
        let url = URL(fileURLWithPath: path)
        print("Playing audio from path: \(path)")
        playAudioFromURL(url: url)
    }

    func playAudioFromURL(urlString: String) {
        if let url = URL(string: urlString), url.scheme != nil {
            // Handle remote URL
            print("Playing audio from remote URL string: \(urlString)")
            playAudioFromURL(url: url)
        } else if let path = Bundle.main.path(forResource: urlString, ofType: "mp3") {
            // Handle local file in bundle
            let url = URL(fileURLWithPath: path)
            print("Playing audio from local path: \(path)")
            playAudioFromURL(url: url)
        } else {
            print("Invalid URL or file not found in bundle: \(urlString)")
        }
    }

    func playAudioFromURL(url: URL) {
        AudioSessionManager.activateAudioSession()
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = delegate
            player?.play()
        } catch {
            print("Failed to play audio from URL: \(url.absoluteString). Error: \(error.localizedDescription)")
        }
    }

    func pausePlayback() {
        player?.pause()
    }

    func stopPlayback() {
        player?.stop()
        player = nil
    }
}
