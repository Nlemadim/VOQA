//
//  UserConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation

// User Configuration Model
struct UserConfig: Codable {
    var username: String
    var email: String
    var voice: String
    var currentUserVoqaID: String?  // Only storing the id property of currentUserVoqa
    var quizCollection: [String]  // Array of voqaIds
    var accountType: String  // Storing account type as a string tag
    var subscriptionPackages: [String]  // Storing subscription packages as string tags
    var badges: [String]  // Storing badges as string tags
    
    init(username: String = "", email: String = "", voice: String = "", currentUserVoqaID: String? = nil, quizCollection: [String] = [], accountType: String = AccountType.guest.rawValue, subscriptionPackages: [String] = [], badges: [String] = []) {
        self.username = username
        self.email = email
        self.voice = voice
        self.currentUserVoqaID = currentUserVoqaID
        self.quizCollection = quizCollection
        self.accountType = accountType
        self.subscriptionPackages = subscriptionPackages
        self.badges = badges
    }
}
