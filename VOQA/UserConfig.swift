//
//  UserConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation

struct UserConfig: Codable {
    var username: String
    var email: String
    var voice: String
    var currentUserVoqaID: String?  // Storing the ID of the current Voqa
    var quizCollection: [String]  // Array of Voqa IDs
    var accountType: String  // Account type as a string tag
    var subscriptionPackages: [String]  // Subscription packages as string tags
    var badges: [String]  // Badges as string tags
    
    // Updated properties for add-on selections
    var selectedVoiceNarrator: String
    var selectedBackgroundMusic: String?
    var selectedSoundEffect: String?
    
    // New properties
    var firstCreated: Date  // Date when the user config was first created
    var userId: String  // User ID as a string

    init(
        username: String = "",
        email: String = "",
        voice: String = "Gus",  // Default to "Gus"
        currentUserVoqaID: String? = nil,
        quizCollection: [String] = [],
        accountType: String = AccountType.guest.rawValue,
        subscriptionPackages: [String] = [],
        badges: [String] = [],
        selectedVoiceNarrator: String = "Gus",  // Default to "Gus"
        selectedBackgroundMusic: String? = nil,  // Default to nil
        selectedSoundEffect: String? = nil,
        firstCreated: Date = .now,  // Default to the current date and time
        userId: String = UUID().uuidString  // Default to a new UUID string
    ) {
        self.username = username
        self.email = email
        self.voice = voice
        self.currentUserVoqaID = currentUserVoqaID
        self.quizCollection = quizCollection
        self.accountType = accountType
        self.subscriptionPackages = subscriptionPackages
        self.badges = badges
        self.selectedVoiceNarrator = selectedVoiceNarrator
        self.selectedBackgroundMusic = selectedBackgroundMusic
        self.selectedSoundEffect = selectedSoundEffect
        self.firstCreated = firstCreated
        self.userId = userId
    }
}

