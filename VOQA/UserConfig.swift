//
//  UserConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation
import Combine


// MARK: - UserConfig Class

class UserConfig: ObservableObject, Codable {
    // Published properties
    @Published var username: String
    @Published var email: String
    @Published var voice: String
    @Published var currentUserVoqaID: String?
    @Published var quizCollection: [String]
    @Published var accountType: String
    @Published var subscriptionPackages: [String]
    @Published var badges: [String]
    @Published var selectedVoiceNarrator: String
    @Published var selectedBackgroundMusic: String?
    @Published var selectedSoundEffect: String?
    @Published var firstCreated: Date
    @Published var userId: String
    
    // Private property to hold Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // UserDefaults key
    static let userConfigKey = "userConfig"
    
    // MARK: - Initializer
    
    init() {
        // Attempt to load existing UserConfig from UserDefaults
        if let data = UserDefaults.standard.data(forKey: UserConfig.userConfigKey),
           let decodedConfig = try? JSONDecoder().decode(UserConfig.self, from: data) {
            self.username = decodedConfig.username
            self.email = decodedConfig.email
            self.voice = decodedConfig.voice
            self.currentUserVoqaID = decodedConfig.currentUserVoqaID
            self.quizCollection = decodedConfig.quizCollection
            self.accountType = decodedConfig.accountType
            self.subscriptionPackages = decodedConfig.subscriptionPackages
            self.badges = decodedConfig.badges
            self.selectedVoiceNarrator = decodedConfig.selectedVoiceNarrator
            self.selectedBackgroundMusic = decodedConfig.selectedBackgroundMusic
            self.selectedSoundEffect = decodedConfig.selectedSoundEffect
            self.firstCreated = decodedConfig.firstCreated
            self.userId = decodedConfig.userId
            print("UserConfig loaded successfully for userId: \(self.userId)")
        } else {
            // No existing config found; create a default guest config
            self.username = "Guest"
            self.email = ""
            self.voice = "Gus"
            self.currentUserVoqaID = nil
            self.quizCollection = []
            self.accountType = AccountType.guest.rawValue
            self.subscriptionPackages = []
            self.badges = []
            self.selectedVoiceNarrator = "Gus"
            self.selectedBackgroundMusic = nil
            self.selectedSoundEffect = nil
            self.firstCreated = Date()
            self.userId = UUID().uuidString
            print("Created guest UserConfig with userId: \(self.userId)")
            saveToDefaults()
        }
        
        // Setup automatic saving on property changes
        setupAutoSave()
    }
    
    // MARK: - Codable Conformance
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case voice
        case currentUserVoqaID
        case quizCollection
        case accountType
        case subscriptionPackages
        case badges
        case selectedVoiceNarrator
        case selectedBackgroundMusic
        case selectedSoundEffect
        case firstCreated
        case userId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.voice = try container.decode(String.self, forKey: .voice)
        self.currentUserVoqaID = try container.decodeIfPresent(String.self, forKey: .currentUserVoqaID)
        self.quizCollection = try container.decode([String].self, forKey: .quizCollection)
        self.accountType = try container.decode(String.self, forKey: .accountType)
        self.subscriptionPackages = try container.decode([String].self, forKey: .subscriptionPackages)
        self.badges = try container.decode([String].self, forKey: .badges)
        self.selectedVoiceNarrator = try container.decode(String.self, forKey: .selectedVoiceNarrator)
        self.selectedBackgroundMusic = try container.decodeIfPresent(String.self, forKey: .selectedBackgroundMusic)
        self.selectedSoundEffect = try container.decodeIfPresent(String.self, forKey: .selectedSoundEffect)
        self.firstCreated = try container.decode(Date.self, forKey: .firstCreated)
        self.userId = try container.decode(String.self, forKey: .userId)
        
        // Setup automatic saving on property changes
        setupAutoSave()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(voice, forKey: .voice)
        try container.encodeIfPresent(currentUserVoqaID, forKey: .currentUserVoqaID)
        try container.encode(quizCollection, forKey: .quizCollection)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(subscriptionPackages, forKey: .subscriptionPackages)
        try container.encode(badges, forKey: .badges)
        try container.encode(selectedVoiceNarrator, forKey: .selectedVoiceNarrator)
        try container.encodeIfPresent(selectedBackgroundMusic, forKey: .selectedBackgroundMusic)
        try container.encodeIfPresent(selectedSoundEffect, forKey: .selectedSoundEffect)
        try container.encode(firstCreated, forKey: .firstCreated)
        try container.encode(userId, forKey: .userId)
    }
    
    // MARK: - Automatic Saving Setup
    
    private func setupAutoSave() {
        // Observe any changes to @Published properties and save to UserDefaults
        self.objectWillChange
            .sink { [weak self] _ in
                self?.saveToDefaults()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Persistence Methods
    
    /// Save the current UserConfig to UserDefaults
    func saveToDefaults() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: UserConfig.userConfigKey)
            print("UserConfig saved successfully for userId: \(userId)")
        } catch {
            print("Failed to save UserConfig: \(error.localizedDescription)")
        }
    }
    
    /// Create a new guest UserConfig and save it
    static func createGuest() -> UserConfig {
        let guestConfig = UserConfig()
        guestConfig.saveToDefaults()
        return guestConfig
    }
}


