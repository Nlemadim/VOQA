//
//  User.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation
import SwiftUI
import Combine

class User: ObservableObject {
    // Published properties
    @Published var userConfig: UserConfig
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var isLoggedIn: Bool = false
    @Published var voqaCollection: [Voqa] = []
    @Published var currentUserVoqa: Voqa?
    @Published var accessItems: [SubscriptionPackageAccess] = []
    
    // Private property to hold Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init() {
        // Initialize userConfig; this will load existing or create guest config
        self.userConfig = UserConfig()
        self.accessItems = []
        
        // Initialize other properties based on userConfig
        self.email = userConfig.email
        self.fullName = userConfig.username
        
        // Observe changes in userConfig and update User's own properties accordingly
        userConfig.$email
            .receive(on: RunLoop.main)
            .assign(to: \.email, on: self)
            .store(in: &cancellables)
        
        userConfig.$username
            .receive(on: RunLoop.main)
            .assign(to: \.fullName, on: self)
            .store(in: &cancellables)
        
        // Update isLoggedIn based on accountType
        userConfig.$accountType
            .receive(on: RunLoop.main)
            .map { $0 != AccountType.guest.rawValue }
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - User Actions
    
    /// Continue as guest by resetting to a new guest UserConfig
    func continueAsGuest() {
        self.userConfig = UserConfig.createGuest()
        self.email = userConfig.email
        self.fullName = userConfig.username
        self.isLoggedIn = false
    }
    
    // MARK: - Credential Management
    
    /// Save user credentials securely
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
        
        // Update userConfig with new details
        userConfig.username = fullName
        userConfig.email = email
        // No need to call saveToDefaults() since UserConfig automatically saves on changes
        
        print("User details saved:")
        print("Email: \(email)")
        print("Full Name: \(fullName)")
        print("Password: \(password)")
    }
    
    /// Retrieve saved credentials
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
    
    /// Clear credentials and reset to guest configuration
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
        
        // Reset userConfig to guest
        self.userConfig = UserConfig()
    }
    
    /// Delete user configuration and reset to guest
    func deleteUserConfig() {
        UserDefaults.standard.removeObject(forKey: UserConfig.userConfigKey)
        self.userConfig = UserConfig()
        print("UserConfig deleted and reset to guest configuration.")
    }
    
    // MARK: - User Profile Creation
    
    /// Create user profile from userConfig
    func createUserProfile() -> UserProfile {
        // Create the user profile
        let userProfile = UserProfile(
            firstCreated: userConfig.firstCreated,
            userId: userConfig.userId,
            username: userConfig.username,  // Ensure this aligns with the backend's expected "username" field
            email: userConfig.email,
            voqaCollection: userConfig.quizCollection,
            voiceNarrator: [userConfig.selectedVoiceNarrator],
            backgroundMusic: userConfig.selectedBackgroundMusic.map { [$0] } ?? [],
            backgroundSFX: userConfig.selectedSoundEffect.map { [$0] } ?? []
        )
        
        // Debug print statements to log the user profile properties
        print("UserProfile Data Being Sent to Server:")
        print("firstCreated: \(userProfile.firstCreated)")
        print("userId: \(userProfile.userId)")
        print("userName: \(userProfile.username)") // Ensure correct casing
        print("email: \(userProfile.email)")
        print("voqaCollection: \(userProfile.voqaCollection)")
        print("voiceNarrator: \(userProfile.voiceNarrator)")
        print("backgroundMusic: \(userProfile.backgroundMusic)")
        print("backgroundSFX: \(userProfile.backgroundSFX)")
        
        return userProfile
    }
}
