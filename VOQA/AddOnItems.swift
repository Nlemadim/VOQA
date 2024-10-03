//
//  AddOnItems.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/28/24.
//

import Foundation

struct AddOnItem: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    var isSelected: Bool
    let about: String
    let audioURL: URL?  // Optional property to store audio URL
    var isPaid: Bool? // Optional flag to indicate if the item is paid
    var path: String? // Optional property to store the path for local configurations
    var isAvailableOffline: Bool? // Optional flag to indicate if the item is available offline
    var voiceId: String?

    init(
        id: UUID = UUID(),
        name: String,
        imageName: String,
        isSelected: Bool = false,
        about: String,
        audioURL: URL? = nil,  // Default to nil
        isPaid: Bool? = nil, // Default to nil for backward compatibility
        path: String? = nil, // Default to nil for backward compatibility
        isAvailableOffline: Bool? = nil, // Default to nil for backward compatibility
        voiceId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.isSelected = isSelected
        self.about = about
        self.audioURL = audioURL
        self.isPaid = isPaid
        self.path = path
        self.isAvailableOffline = isAvailableOffline
        self.voiceId = voiceId
    }
}


extension AddOnItem {
    static var defaultMusicItems: [AddOnItem] {
        return [
            AddOnItem(id: UUID(), name: "Calm Waves", imageName: "MusicIcon", isSelected: false, about: "Calm and soothing wave sounds for relaxation.", audioURL: URL(string: "https://example.com/calm_waves.mp3"), isAvailableOffline: true),
            AddOnItem(id: UUID(), name: "Jazz Beats", imageName: "MusicIcon", isSelected: false, about: "Smooth jazz beats to keep you focused.", audioURL: URL(string: "https://example.com/jazz_beats.mp3"), isAvailableOffline: true),
            AddOnItem(id: UUID(), name: "Nature Sounds", imageName: "MusicIcon", isSelected: false, about: "Peaceful nature sounds to enhance your learning experience.", audioURL: URL(string: "https://example.com/nature_sounds.mp3"), isAvailableOffline: true),
            AddOnItem(id: UUID(), name: "Classical Piano", imageName: "MusicIcon", isSelected: false, about: "Elegant classical piano music for deep concentration.", audioURL: URL(string: "https://example.com/classical_piano.mp3"), isAvailableOffline: true)
        ]
    }
    
    static var defaultNarratorItems: [AddOnItem] {
        return [
            AddOnItem(
                id: UUID(),
                name: "Gus",
                imageName: "Gus",
                isSelected: false,
                about: "Gus is a straight to the point narrator who will keep things moving without much delay.",
                audioURL: URL(string: "https://example.com/gus_voice.mp3"),
                isPaid: false,
                path: "GusNarratorConfiguration", // Updated path to match the new file naming convention
                voiceId: ""
            ),
            AddOnItem(
                id: UUID(),
                name: "Erin",
                imageName: "Erin",
                isSelected: false,
                about: "Erin is an ancient librarian. She is very thorough and values accuracy very highly.",
                audioURL: URL(string: "https://example.com/erin_voice.mp3"),
                isPaid: false,
                path: "ErinNarratorConfiguration",
                voiceId: ""// Updated path to match the new file naming convention
            ),
            AddOnItem(
                id: UUID(),
                name: "Ini",
                imageName: "Ini",
                isSelected: false,
                about: "Counter Sports Prediction Specialist",
                audioURL: URL(string: "https://example.com/ini_voice.mp3"),
                isPaid: false,
                path: "IniNarratorConfiguration" ,
                voiceId: ""// Updated path to match the new file naming convention
            ),
            AddOnItem(
                id: UUID(),
                name: "Dogon Yaro",
                imageName: "DogonYaro",
                isSelected: false,
                about: "Bio-Artificial Ent",
                audioURL: URL(string: "https://example.com/dogon_yaro_voice.mp3"),
                isPaid: false,
                path: "DogonYaroNarratorConfiguration",
                voiceId: ""// Updated path to match the new file naming convention
            ),
            AddOnItem(
                id: UUID(),
                name: "Amina",
                imageName: "Amina",
                isSelected: false,
                about: "Mystic Queen",
                audioURL: URL(string: "https://example.com/dogon_yaro_voice.mp3"),
                isPaid: false,
                path: "DogonYaroNarratorConfiguration",
                voiceId: ""// Updated path to match the new file naming convention
            ),
            AddOnItem(
                id: UUID(),
                name: "Dross",
                imageName: "Dross",
                isSelected: false,
                about: "17th Generation Mindbot",
                audioURL: URL(string: "https://example.com/dogon_yaro_voice.mp3"),
                isPaid: false,
                path: "DrossNarratorConfiguration",
                voiceId: ""// Updated path to match the new file naming convention
            ),
            AddOnItem(
                id: UUID(),
                name: "Dr Butters",
                imageName: "DrButters",
                isSelected: false,
                about: "Mad Techno-human Biologist",
                audioURL: URL(string: "https://example.com/dogon_yaro_voice.mp3"),
                isPaid: false,
                path: "DrossNarratorConfiguration" // Updated path to match the new file naming convention
            )
        ]
    }
    
    static var defaultSoundEffectItems: [AddOnItem] {
        return [
            AddOnItem(id: UUID(), name: "Rainfall", imageName: "Raindrops", isSelected: false, about: "Gentle rainfall sound to create a calming atmosphere.", audioURL: URL(string: "https://example.com/rainfall.mp3"), isAvailableOffline: true),
            AddOnItem(id: UUID(), name: "Waterfall", imageName: "Waterfall", isSelected: false, about: "Soft sounds of water crashing on the rocks.", audioURL: URL(string: "https://example.com/wind_blowing.mp3"), isAvailableOffline: true),
            AddOnItem(id: UUID(), name: "Ocean Waves", imageName: "OceanWaves", isSelected: false, about: "Relaxing ocean waves for a serene background.", audioURL: URL(string: "https://example.com/ocean_waves.mp3"), isAvailableOffline: true)
        ]
    }
}

