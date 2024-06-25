//
//  Question.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class Question: ObservableObject, Decodable {
    @Attribute(.unique) var id: UUID
    var topicId: UUID
    var content: String
    var options: [String]
    var correctOption: String
    var selectedOption: String = ""
    var isAnswered: Bool = false
    var isAnsweredCorrectly: Bool
    var numberOfPresentations: Int
    var ratings: Int
    var numberOfRatings: Int
    var audioScript: String
    var audioUrl: String
    var replayQuestionAudioScript: String
    var replayOptionAudioScript: String
    var status: QuestionStatus
    var difficultyLevel: Int // An indicator of the question's difficulty, mapped from TopicCategory
    var answerPresentedDate: Date? // Tracks when the answer was presented to the user

    init(id: UUID = UUID(), topicId: UUID, content: String, options: [String], correctOption: String, selectedOption: String = "", isAnswered: Bool = false, isAnsweredCorrectly: Bool, numberOfPresentations: Int = 0, ratings: Int = 0, numberOfRatings: Int = 0, audioScript: String, audioUrl: String, replayQuestionAudioScript: String, replayOptionAudioScript: String, status: QuestionStatus, difficultyLevel: Int, answerPresentedDate: Date? = nil) {
        self.id = id
        self.topicId = topicId
        self.content = content
        self.options = options
        self.correctOption = correctOption
        self.selectedOption = selectedOption
        self.isAnswered = isAnswered
        self.isAnsweredCorrectly = isAnsweredCorrectly
        self.numberOfPresentations = numberOfPresentations
        self.ratings = ratings
        self.numberOfRatings = numberOfRatings
        self.audioScript = audioScript
        self.audioUrl = audioUrl
        self.replayQuestionAudioScript = replayQuestionAudioScript
        self.replayOptionAudioScript = replayOptionAudioScript
        self.status = status
        self.difficultyLevel = difficultyLevel
        self.answerPresentedDate = answerPresentedDate
    }
    
    convenience init(id: UUID = UUID()) {
        self.init(id: id, topicId: UUID(), content: "", options: [], correctOption: "", isAnsweredCorrectly: false, audioScript: "", audioUrl: "", replayQuestionAudioScript: "", replayOptionAudioScript: "", status: .newQuestion, difficultyLevel: TopicCategory.foundational.rawValue)
    }
    
    convenience init(id: UUID = UUID(), topicId: UUID, content: String, options: [String], correctOption: String, audioScript: String, audioUrl: String, replayQuestionAudioScript: String, replayOptionAudioScript: String, topicCategory: TopicCategory) {
        self.init(id: id, topicId: topicId, content: content, options: options, correctOption: correctOption, isAnsweredCorrectly: false, audioScript: audioScript, audioUrl: audioUrl, replayQuestionAudioScript: replayQuestionAudioScript, replayOptionAudioScript: replayOptionAudioScript, status: .newQuestion, difficultyLevel: topicCategory.rawValue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, topicId, content, options, correctOption, selectedOption, isAnswered, isAnsweredCorrectly, numberOfPresentations, ratings, numberOfRatings, audioScript, audioUrl, replayQuestionAudioScript, replayOptionAudioScript, status, difficultyLevel, answerPresentedDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.topicId = try container.decode(UUID.self, forKey: .topicId)
        self.content = try container.decode(String.self, forKey: .content)
        self.options = try container.decode([String].self, forKey: .options)
        self.correctOption = try container.decode(String.self, forKey: .correctOption)
        self.selectedOption = try container.decode(String.self, forKey: .selectedOption)
        self.isAnswered = try container.decode(Bool.self, forKey: .isAnswered)
        self.isAnsweredCorrectly = try container.decode(Bool.self, forKey: .isAnsweredCorrectly)
        self.numberOfPresentations = try container.decode(Int.self, forKey: .numberOfPresentations)
        self.ratings = try container.decode(Int.self, forKey: .ratings)
        self.numberOfRatings = try container.decode(Int.self, forKey: .numberOfRatings)
        self.audioScript = try container.decode(String.self, forKey: .audioScript)
        self.audioUrl = try container.decode(String.self, forKey: .audioUrl)
        self.replayQuestionAudioScript = try container.decode(String.self, forKey: .replayQuestionAudioScript)
        self.replayOptionAudioScript = try container.decode(String.self, forKey: .replayOptionAudioScript)
        self.status = try container.decode(QuestionStatus.self, forKey: .status)
        self.difficultyLevel = try container.decode(Int.self, forKey: .difficultyLevel)
        self.answerPresentedDate = try container.decodeIfPresent(Date.self, forKey: .answerPresentedDate)
    }
}
