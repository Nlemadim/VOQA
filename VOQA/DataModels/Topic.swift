//
//  Topic.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class Topic: Decodable {
    @Attribute(.unique) var topicId: UUID
    var topicTitle: String
    var topicCategory: TopicCategory
    var learningIndex: Int
    var presentations: Int
    var dateLastPresented: Date? // Optional
    var progress: Double // A value between 0 and 1 indicating progress within the topic
    @Relationship(deleteRule: .cascade) var questions: [Question] = []

    init(topicId: UUID = UUID(), topicTitle: String, topicCategory: TopicCategory, learningIndex: Int, presentations: Int = 0, dateLastPresented: Date? = nil, progress: Double = 0.0) {
        self.topicId = topicId
        self.topicTitle = topicTitle
        self.topicCategory = topicCategory
        self.learningIndex = learningIndex
        self.presentations = presentations
        self.dateLastPresented = dateLastPresented
        self.progress = progress
    }
    
    private enum CodingKeys: String, CodingKey {
        case topicId, topicTitle, topicCategory, learningIndex, presentations, dateLastPresented, progress
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topicId = try container.decode(UUID.self, forKey: .topicId)
        self.topicTitle = try container.decode(String.self, forKey: .topicTitle)
        self.topicCategory = try container.decode(TopicCategory.self, forKey: .topicCategory)
        self.learningIndex = try container.decode(Int.self, forKey: .learningIndex)
        self.presentations = try container.decode(Int.self, forKey: .presentations)
        self.dateLastPresented = try container.decodeIfPresent(Date.self, forKey: .dateLastPresented)
        self.progress = try container.decode(Double.self, forKey: .progress)
    }
}
