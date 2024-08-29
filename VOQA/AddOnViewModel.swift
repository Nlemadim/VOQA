//
//  AddOnViewModel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation
import SwiftUI
import Combine

import SwiftUI
import Combine

class AddOnViewModel: ObservableObject {
    // Available add-on items
    @Published var availableVoiceNarrators: [AddOnItem] = AddOnItem.defaultNarratorItems
    @Published var availableMusicTracks: [AddOnItem] = AddOnItem.defaultMusicItems
    @Published var availableSoundEffects: [AddOnItem] = AddOnItem.defaultSoundEffectItems
    
    // Current selections
    @Published var selectedVoiceNarrator: AddOnItem?
    @Published var selectedBackgroundMusic: AddOnItem?
    @Published var selectedSoundEffect: AddOnItem?
    
    // Download states
    @Published var isDownloading: Bool = false
    @Published var downloadProgress: Double = 0.0
    
    // Reference to the user object
    private var user: User
    private var audioPlayer = AddOnAudioPlayer()
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        // Initialize selections from user config
        self.selectedVoiceNarrator = availableVoiceNarrators.first { $0.name == user.userConfig.selectedVoiceNarrator }
        self.selectedBackgroundMusic = availableMusicTracks.first { $0.name == user.userConfig.selectedBackgroundMusic }
        self.selectedSoundEffect = availableSoundEffects.first { $0.name == user.userConfig.selectedSoundEffect }
    }
    
    // Method to select a voice narrator
    func selectVoiceNarrator(_ narrator: AddOnItem) {
        availableVoiceNarrators.indices.forEach { index in
            availableVoiceNarrators[index].isSelected = availableVoiceNarrators[index].id == narrator.id
        }
        selectedVoiceNarrator = narrator
        user.updateVoiceNarrator(narrator.name)
    }
    
    // Method to select background music
    func selectBackgroundMusic(_ music: AddOnItem) {
        availableMusicTracks.indices.forEach { index in
            availableMusicTracks[index].isSelected = availableMusicTracks[index].id == music.id
        }
        selectedBackgroundMusic = music
        user.updateBackgroundMusic(music.name)
    }

    // Method to select a sound effect
    func selectSoundEffect(_ effect: AddOnItem) {
        availableSoundEffects.indices.forEach { index in
            availableSoundEffects[index].isSelected = availableSoundEffects[index].id == effect.id
        }
        selectedSoundEffect = effect
        user.updateSoundEffect(effect.name)
    }
    
    // Method to download and play audio sample
    func downloadAndPlaySample(for item: AddOnItem) {
        guard let audioURL = item.audioURL else {
            print("No audio URL available for this item.")
            return
        }
        
        isDownloading = true
        downloadProgress = 0.0
        
        audioPlayer.playAudio(from: audioURL) { success in
            DispatchQueue.main.async {
                self.isDownloading = false
                self.downloadProgress = success ? 1.0 : 0.0
                if !success {
                    print("Failed to play audio.")
                }
            }
        }
    }
}
