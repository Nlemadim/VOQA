//
//  AudioPlayerManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import AVFoundation

class AudioPlayerManager: NSObject {
    var player: AVAudioPlayer?
    weak var delegate: AVAudioPlayerDelegate?

    func playAudioFromURL(urlString: String) {
        if let url = URL(string: urlString), url.scheme != nil {
            // Handle remote URL
            print("Playing audio from remote URL string: \(urlString)")
            downloadAndPlayAudio(from: url)
        } else {
            // Handle local file in bundle
            guard let path = Bundle.main.path(forResource: urlString, ofType: "mp3") else {
                print("Invalid URL or file not found in bundle: \(urlString)")
                return
            }
            let url = URL(fileURLWithPath: path)
            print("Playing audio from local path: \(path)")
            playAudioFromURL(url: url)
        }
    }

    private func downloadAndPlayAudio(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to download audio data: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received from URL: \(url.absoluteString)")
                return
            }
            do {
                self.player = try AVAudioPlayer(data: data)
                self.player?.delegate = self.delegate
                self.player?.play()
            } catch {
                print("Failed to play audio from data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func playAudioFromURL(url: URL) {
        AudioSessionManager.activateAudioSession()
        if url.isFileURL {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.delegate = delegate
                player?.play()
            } catch {
                print("Failed to play audio from URL: \(url.absoluteString). Error: \(error.localizedDescription)")
            }
        } else {
            downloadAndPlayAudio(from: url)
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



//class AudioPlayerManager: NSObject {
//    var player: AVAudioPlayer?
//    weak var delegate: AVAudioPlayerDelegate?
//
//    func playAudio(fileName: String, fileType: String) {
//        guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
//            print("Sound file not found: \(fileName).\(fileType)")
//            return
//        }
//        let url = URL(fileURLWithPath: path)
//        print("Playing audio from path: \(path)")
//        playAudioFromURL(url: url)
//    }
//
//    func playAudioFromURL(urlString: String) {
//        if let url = URL(string: urlString), url.scheme != nil {
//            // Handle remote URL
//            print("Playing audio from remote URL string: \(urlString)")
//            downloadAndPlayAudio(from: url)
//        } else if let path = Bundle.main.path(forResource: urlString, ofType: "mp3") {
//            // Handle local file in bundle
//            let url = URL(fileURLWithPath: path)
//            print("Playing audio from local path: \(path)")
//            playAudioFromURL(url: url)
//        } else {
//            print("Invalid URL or file not found in bundle: \(urlString)")
//        }
//    }
//
//    private func downloadAndPlayAudio(from url: URL) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Failed to download audio data: \(error.localizedDescription)")
//                return
//            }
//            guard let data = data else {
//                print("No data received from URL: \(url.absoluteString)")
//                return
//            }
//            do {
//                self.player = try AVAudioPlayer(data: data)
//                self.player?.delegate = self.delegate
//                self.player?.play()
//            } catch {
//                print("Failed to play audio from data: \(error.localizedDescription)")
//            }
//        }
//        task.resume()
//    }
//
//    func playAudioFromURL(url: URL) {
//        AudioSessionManager.activateAudioSession()
//        if url.isFileURL {
//            do {
//                player = try AVAudioPlayer(contentsOf: url)
//                player?.delegate = delegate
//                player?.play()
//            } catch {
//                print("Failed to play audio from URL: \(url.absoluteString). Error: \(error.localizedDescription)")
//            }
//        } else {
//            downloadAndPlayAudio(from: url)
//        }
//    }
//
//    func pausePlayback() {
//        player?.pause()
//    }
//
//    func stopPlayback() {
//        player?.stop()
//        player = nil
//    }
//}
