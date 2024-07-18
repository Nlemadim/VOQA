//
//  SfxPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/16/24.
//

import AVFoundation
import Foundation

enum PlaySfx {
    case awaitResponse
    case hasReceivedResponse
    case nextQuestion
    case introMusic

    var fileName: String {
        switch self {
        case .awaitResponse:
            return "showResponderBell"
        case .hasReceivedResponse:
            return "dismissResponderBell"
        case .nextQuestion:
            return "NextQuestionWave"
        case .introMusic:
            return ""
        }
    }

    var fileExtension: String {
        return "wav" // Assuming all files have .mp3 extension
    }
}

class SfxPlayer: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    func play(_ action: PlaySfx) {
        guard let url = Bundle.main.url(forResource: action.fileName, withExtension: action.fileExtension) else {
            print("Audio file not found: \(action.fileName).\(action.fileExtension)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play audio file: \(error.localizedDescription)")
        }
    }

    // AVAudioPlayerDelegate methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle audio finished playing if needed
    }
}

