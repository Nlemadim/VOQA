//
//  AddOnViewModel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation
import SwiftUI
import Combine


class AddOnViewModel: ObservableObject {
    // MARK: - Properties
    
    var databaseManager: DatabaseManager
    @Published var availableVoiceNarrators: [AddOnItem] = AddOnItem.defaultNarratorItems
    @Published var availableMusicTracks: [AddOnItem] = AddOnItem.defaultMusicItems
    @Published var availableSoundEffects: [AddOnItem] = AddOnItem.defaultSoundEffectItems
    
    @Published var selectedVoiceNarrator: AddOnItem?
    @Published var selectedBackgroundMusic: AddOnItem?
    @Published var selectedSoundEffect: AddOnItem?
    
    @Published var isDownloading: Bool = false
    @Published var downloadProgress: Double = 0.0
    
    private var user: User
    private var audioPlayer = AddOnAudioPlayer()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(user: User, databaseManager: DatabaseManager) {
        self.user = user
        self.databaseManager = databaseManager
        
        // Initialize selections from user config
        self.selectedVoiceNarrator = availableVoiceNarrators.first { $0.name == user.userConfig.selectedVoiceNarrator }
        self.selectedBackgroundMusic = availableMusicTracks.first { $0.name == user.userConfig.selectedBackgroundMusic }
        self.selectedSoundEffect = availableSoundEffects.first { $0.name == user.userConfig.selectedSoundEffect }
        
        // Optionally, observe changes in UserConfig to keep selections in sync
        setupObservers()
    }
    
    // MARK: - Observers
    private func setupObservers() {
        // Observe UserConfig's selectedVoiceNarrator and update selectedVoiceNarrator accordingly
        user.userConfig.$selectedVoiceNarrator
            .receive(on: RunLoop.main)
            .map { narratorName in
                self.availableVoiceNarrators.first { $0.name == narratorName }
            }
            .assign(to: \.selectedVoiceNarrator, on: self)
            .store(in: &cancellables)
        
        // Observe UserConfig's selectedBackgroundMusic and update selectedBackgroundMusic accordingly
        user.userConfig.$selectedBackgroundMusic
            .receive(on: RunLoop.main)
            .map { musicName in
                self.availableMusicTracks.first { $0.name == musicName }
            }
            .assign(to: \.selectedBackgroundMusic, on: self)
            .store(in: &cancellables)
        
        // Observe UserConfig's selectedSoundEffect and update selectedSoundEffect accordingly
        user.userConfig.$selectedSoundEffect
            .receive(on: RunLoop.main)
            .map { effectName in
                self.availableSoundEffects.first { $0.name == effectName }
            }
            .assign(to: \.selectedSoundEffect, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Selection Methods
    
    /// Select a voice narrator
    func selectVoiceNarrator(_ narrator: AddOnItem) {
        // Update selection states
        for index in availableVoiceNarrators.indices {
            availableVoiceNarrators[index].isSelected = (availableVoiceNarrators[index].id == narrator.id)
        }
        selectedVoiceNarrator = narrator
        
        // Update UserConfig directly
        user.userConfig.selectedVoiceNarrator = narrator.name
        
        // Load voice configuration asynchronously
        Task {
            await loadVoiceConfig(narrator)
        }
    }
    
    /// Select background music
    func selectBackgroundMusic(_ music: AddOnItem) {
        // Update selection states
        for index in availableMusicTracks.indices {
            availableMusicTracks[index].isSelected = (availableMusicTracks[index].id == music.id)
        }
        selectedBackgroundMusic = music
        
        // Update UserConfig directly
        user.userConfig.selectedBackgroundMusic = music.name
    }
    
    /// Select a sound effect
    func selectSoundEffect(_ effect: AddOnItem) {
        // Update selection states
        for index in availableSoundEffects.indices {
            availableSoundEffects[index].isSelected = (availableSoundEffects[index].id == effect.id)
        }
        selectedSoundEffect = effect
        
        // Update UserConfig directly
        user.userConfig.selectedSoundEffect = effect.name
    }
    
    // MARK: - Loading Configurations
    
    private func loadVoiceConfig(_ narrator: AddOnItem) async {
        do {
            try await databaseManager.loadVoiceConfiguration(for: narrator)
        } catch {
            print("Error loading voice configuration for \(narrator.name): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Download and Play Audio Sample
    
    func downloadAndPlaySample(for item: AddOnItem) {
        guard let audioURL = item.audioURL else {
            print("No audio URL available for this item.")
            return
        }
        
        isDownloading = true
        downloadProgress = 0.0
        
        audioPlayer.playAudio(from: audioURL) { [weak self] success in
            DispatchQueue.main.async {
                self?.isDownloading = false
                self?.downloadProgress = success ? 1.0 : 0.0
                if !success {
                    print("Failed to play audio for \(item.name).")
                }
            }
        }
    }
}
