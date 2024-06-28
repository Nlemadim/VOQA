//
//  AudioQuiz.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
final class AudioQuiz: Decodable {
    @Attribute(.unique) var id: UUID
    var quizTitle: String
    var titleImage: String
    var shortTitle: String = "VOQA"
    var firstStarted: Date
    var completions: Int
    var userHighScore: Int
    var ratings: Int
    var currentQuizTopicIDs: [String] = []
    @Relationship(deleteRule: .cascade) var topics: [Topic] = []

    init(
        id: UUID = UUID(),
        quizTitle: String,
        titleImage: String,
        shortTitle: String = "VOQA",
        firstStarted: Date,
        completions: Int = 0,
        userHighScore: Int = 0,
        ratings: Int = 0,
        currentQuizTopicIDs: [String] = [],
        topics: [Topic] = []
    ) {
        self.id = id
        self.quizTitle = quizTitle
        self.titleImage = titleImage
        self.shortTitle = shortTitle
        self.firstStarted = firstStarted
        self.completions = completions
        self.userHighScore = userHighScore
        self.ratings = ratings
        self.currentQuizTopicIDs = currentQuizTopicIDs
        self.topics = topics
    }
    
    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id
        case quizTitle
        case titleImage
        case shortTitle
        case firstStarted
        case completions
        case userHighScore
        case ratings
        case currentQuizTopicIDs
        case topics
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        quizTitle = try container.decode(String.self, forKey: .quizTitle)
        titleImage = try container.decode(String.self, forKey: .titleImage)
        shortTitle = try container.decodeIfPresent(String.self, forKey: .shortTitle) ?? "VOQA"
        firstStarted = try container.decode(Date.self, forKey: .firstStarted)
        completions = try container.decode(Int.self, forKey: .completions)
        userHighScore = try container.decode(Int.self, forKey: .userHighScore)
        ratings = try container.decode(Int.self, forKey: .ratings)
        currentQuizTopicIDs = try container.decodeIfPresent([String].self, forKey: .currentQuizTopicIDs) ?? []
        topics = try container.decodeIfPresent([Topic].self, forKey: .topics) ?? []
    }
}
