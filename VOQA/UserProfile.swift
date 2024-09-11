//
//  UserProfile.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/4/24.
//

import Foundation

struct UserProfile: Codable {
    var firstCreated: Date
    var userId: String
    var username: String
    var email: String
    var questionsAskedId: String = ""
    var performanceHistoryId: String = ""
    var addOnsCollectionId: String = ""
    var voqaCollection: [String]
    var voiceNarrator: [String]
    var backgroundMusic: [String]
    var backgroundSFX: [String]
}
