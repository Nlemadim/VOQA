//
//  UserConfigurations.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class UserConfigurations {
    
    // User ID
    var userID: UUID
    
    // User Name
    @Attribute(.unique) var username: String
    
    // Email
    var email: String?
    
    // Language Preferences
    var preferredLanguage: String
    
    // Theme Preferences
    var preferredTheme: String
    
    // Date Format Preferences
    var dateFormat: String
    
    // Last Login Date
    var lastLoginDate: Date
    
    // Creation Date
    var creationDate: Date
    
    // Voice Selection
    var voiceSelection: String
    
    // Custom Quiz Packages (array of identifiers)
    var customQuizPackages: [Int]
    
    // Standard Quiz Packages (array of identifiers)
    var standardQuizPackages: [Int]
    
    // Audio Quizzes (array of identifiers)
    var audioQuizzes: [Int]
    
    // Initializer with all properties
    init(userID: UUID = UUID(), username: String = "Guest", email: String? = nil, preferredLanguage: String, preferredTheme: String, dateFormat: String, lastLoginDate: Date, creationDate: Date, voiceSelection: String, customQuizPackages: [Int] = [], standardQuizPackages: [Int] = [], audioQuizzes: [Int] = []) {
        self.userID = userID
        self.username = username
        self.email = email
        self.preferredLanguage = preferredLanguage
        self.preferredTheme = preferredTheme
        self.dateFormat = dateFormat
        self.lastLoginDate = lastLoginDate
        self.creationDate = creationDate
        self.voiceSelection = voiceSelection
        self.customQuizPackages = customQuizPackages
        self.standardQuizPackages = standardQuizPackages
        self.audioQuizzes = audioQuizzes
    }
    
    // Initializer with userName and userID only
    convenience init(username: String, userID: UUID = UUID()) {
        self.init(userID: userID, username: username, preferredLanguage: "English", preferredTheme: "Light", dateFormat: "MM/dd/yyyy", lastLoginDate: Date(), creationDate: Date(), voiceSelection: "Default")
    }
    
    // Initializer with userName, userID, and email
    convenience init(username: String, email: String, userID: UUID = UUID()) {
        self.init(userID: userID, username: username, email: email, preferredLanguage: "English", preferredTheme: "Light", dateFormat: "MM/dd/yyyy", lastLoginDate: Date(), creationDate: Date(), voiceSelection: "Default")
    }
}
