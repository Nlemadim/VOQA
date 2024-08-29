//
//  User.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation
import SwiftUI

class User: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var isLoggedIn: Bool = false
    @Published var voqaCollection: [Voqa] = []
    @Published var currentUserVoqa: Voqa?
    @Published var accessItems: [SubscriptionPackageAccess] = []
    @Published var userConfig: UserConfig

    init() {
        self.userConfig = UserConfig()  // Initialize with default values
        self.accessItems = []  // Initialize with an empty list or based on some logic
        loadUserConfig()  // Load user config after initialization
    }
    
    // Method to create user configuration
    func createUserConfig(
        username: String,
        email: String,
        voice: String,
        currentUserVoqaID: String? = nil,
        quizCollection: [String] = [],
        accountType: String = AccountType.guest.rawValue,
        subscriptionPackages: [String] = [],
        badges: [String] = [],
        selectedVoiceNarrator: String = "Gus",  // Default to "Gus"
        selectedBackgroundMusic: String? = nil,  // Default to nil
        selectedSoundEffect: String? = nil
    ) {
        self.userConfig = UserConfig(
            username: username,
            email: email,
            voice: voice,
            currentUserVoqaID: currentUserVoqaID,
            quizCollection: quizCollection,
            accountType: accountType,
            subscriptionPackages: subscriptionPackages,
            badges: badges,
            selectedVoiceNarrator: selectedVoiceNarrator,
            selectedBackgroundMusic: selectedBackgroundMusic,
            selectedSoundEffect: selectedSoundEffect
        )
        saveUserConfig()
    }
    
    // Method to update user configuration
    func updateUserConfig(
        username: String? = nil,
        email: String? = nil,
        voice: String? = nil,
        currentUserVoqaID: String? = nil,
        quizCollection: [String]? = nil,
        accountType: String? = nil,
        subscriptionPackages: [String]? = nil,
        badges: [String]? = nil,
        selectedVoiceNarrator: String? = nil,
        selectedBackgroundMusic: String? = nil,
        selectedSoundEffect: String? = nil
    ) {
        if let username = username {
            self.userConfig.username = username
        }
        if let email = email {
            self.userConfig.email = email
        }
        if let voice = voice {
            self.userConfig.voice = voice
        }
        if let currentUserVoqaID = currentUserVoqaID {
            self.userConfig.currentUserVoqaID = currentUserVoqaID
        }
        if let quizCollection = quizCollection {
            self.userConfig.quizCollection = quizCollection
        }
        if let accountType = accountType {
            self.userConfig.accountType = accountType
        }
        if let subscriptionPackages = subscriptionPackages {
            self.userConfig.subscriptionPackages = subscriptionPackages
        }
        if let badges = badges {
            self.userConfig.badges = badges
        }
        if let selectedVoiceNarrator = selectedVoiceNarrator {
            self.userConfig.selectedVoiceNarrator = selectedVoiceNarrator
        }
        if let selectedBackgroundMusic = selectedBackgroundMusic {
            self.userConfig.selectedBackgroundMusic = selectedBackgroundMusic
        }
        if let selectedSoundEffect = selectedSoundEffect {
            self.userConfig.selectedSoundEffect = selectedSoundEffect
        }
        
        saveUserConfig()
    }
    
    // Methods to update specific add-on selections
    func updateVoiceNarrator(_ narrator: String) {
        userConfig.selectedVoiceNarrator = narrator
        saveUserConfig()
    }
    
    func updateBackgroundMusic(_ music: String?) {
        userConfig.selectedBackgroundMusic = music
        saveUserConfig()
    }
    
    func updateSoundEffect(_ sfx: String?) {
        userConfig.selectedSoundEffect = sfx
        saveUserConfig()
    }

    // Save user credentials securely
    func saveCredentials() {
        let emailKey = "userEmail"
        let passwordKey = "userPassword"
        let fullNameKey = "userFullName"
        let profileImageKey = "userProfileImage"
        
        UserDefaults.standard.set(email, forKey: emailKey)
        UserDefaults.standard.set(fullName, forKey: fullNameKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
        
        if let imageData = profileImage?.pngData() {
            UserDefaults.standard.set(imageData, forKey: profileImageKey)
        }
        
        // Update user configuration with new details
        updateUserConfig(username: fullName, email: email)
        
        print("User details saved:")
        print("Email: \(email)")
        print("Full Name: \(fullName)")
        print("Password: \(password)")
    }
    
    // Retrieve saved credentials
    func loadCredentials() {
        let emailKey = "userEmail"
        let passwordKey = "userPassword"
        let fullNameKey = "userFullName"
        let profileImageKey = "userProfileImage"
        
        email = UserDefaults.standard.string(forKey: emailKey) ?? ""
        password = UserDefaults.standard.string(forKey: passwordKey) ?? ""
        fullName = UserDefaults.standard.string(forKey: fullNameKey) ?? ""
        
        if let imageData = UserDefaults.standard.data(forKey: profileImageKey) {
            profileImage = UIImage(data: imageData)
        } else {
            profileImage = nil
        }
    }
    
    // Clear credentials
    func clearCredentials() {
        let emailKey = "userEmail"
        let passwordKey = "userPassword"
        let fullNameKey = "userFullName"
        let profileImageKey = "userProfileImage"
        
        UserDefaults.standard.removeObject(forKey: emailKey)
        UserDefaults.standard.removeObject(forKey: passwordKey)
        UserDefaults.standard.removeObject(forKey: fullNameKey)
        UserDefaults.standard.removeObject(forKey: profileImageKey)
        
        email = ""
        password = ""
        fullName = ""
        profileImage = nil
    }
    
    // Save user configuration
    private func saveUserConfig() {
        do {
            let data = try JSONEncoder().encode(userConfig)
            UserDefaults.standard.set(data, forKey: "userConfig")
        } catch {
            print("Failed to save user config: \(error.localizedDescription)")
        }
    }
    
    // Load user configuration
    private func loadUserConfig() {
        guard let data = UserDefaults.standard.data(forKey: "userConfig") else {
            return  // Use the default UserConfig already set in init
        }
        do {
            self.userConfig = try JSONDecoder().decode(UserConfig.self, from: data)
        } catch {
            print("Failed to load user config: \(error.localizedDescription)")
        }
    }
    
    // Delete user configuration
    func deleteUserConfig() {
        UserDefaults.standard.removeObject(forKey: "userConfig")
        self.userConfig = UserConfig()  // Reset to default configuration
    }
}
