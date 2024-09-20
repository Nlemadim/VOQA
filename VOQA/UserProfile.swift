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

extension NetworkService {
    
    // Method to post user profile to the backend
    func postUserProfile(_ profile: UserProfile) async throws {
        guard let url = URL(string: ConfigurationUrls.createUserProfile) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(profile)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Network Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user profile"])
        }
    }
}
