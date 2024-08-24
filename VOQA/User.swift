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
    @Published var profileImage: UIImage? = nil // New property for profile image
    @Published var isLoggedIn: Bool = false
    @Published var voqaCollection: [Voqa] = []
    @Published var currentUserVoqa: Voqa?
    
    // Function to save user credentials securely
    func saveCredentials() {
        let emailKey = "userEmail"
        let passwordKey = "userPassword"
        let fullNameKey = "userFullName"
        let profileImageKey = "userProfileImage"
        
        // Save email and full name in UserDefaults
        UserDefaults.standard.set(email, forKey: emailKey)
        UserDefaults.standard.set(fullName, forKey: fullNameKey)
        
        // Save password in UserDefaults (for simplicity; ideally use Keychain)
        UserDefaults.standard.set(password, forKey: passwordKey)
        
        // Save profile image in UserDefaults
        if let imageData = profileImage?.pngData() {
            UserDefaults.standard.set(imageData, forKey: profileImageKey)
        }
        
        // Print user details when credentials are saved
        print("User details saved:")
        print("Email: \(email)")
        print("Full Name: \(fullName)")
        print("Password: \(password)")
    }
    
    // Function to retrieve saved credentials
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
    
    // Function to clear credentials
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
}


