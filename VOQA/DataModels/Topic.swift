//
//  Topic.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

import Foundation
import SwiftUI

@Model
final class Topic: Decodable {
    @Attribute(.unique) var topicId: UUID
    var topicTitle: String
    var topicCategory: TopicCategory
    var learningIndex: Int
    var presentations: Int
    var dateLastPresented: Date? // Optional
    var progress: Double // A value between 0 and 1 indicating progress within the topic
    @Relationship(deleteRule: .cascade) var questions: [Question] = []

    // Original initializer
    init(topicId: UUID = UUID(), topicTitle: String, topicCategory: TopicCategory, learningIndex: Int, presentations: Int = 0, dateLastPresented: Date? = nil, progress: Double = 0.0, questions: [Question] = []) {
        self.topicId = topicId
        self.topicTitle = topicTitle
        self.topicCategory = topicCategory
        self.learningIndex = learningIndex
        self.presentations = presentations
        self.dateLastPresented = dateLastPresented
        self.progress = progress
        self.questions = questions
    }
    
    // Convenience initializer
    convenience init(topicTitle: String, topicCategory: TopicCategory, learningIndex: Int, questions: [Question]) {
        self.init(topicId: UUID(), topicTitle: topicTitle, topicCategory: topicCategory, learningIndex: learningIndex, questions: questions)
    }
    
    // Convenience initializer from decoder
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topicTitle = try container.decode(String.self, forKey: .topicTitle)
        let topicCategory = try container.decode(TopicCategory.self, forKey: .topicCategory)
        let learningIndex = try container.decode(Int.self, forKey: .learningIndex)
        let questions = try container.decode([Question].self, forKey: .questions)
        
        self.init(topicTitle: topicTitle, topicCategory: topicCategory, learningIndex: learningIndex, questions: questions)
        
        // Assign default values to properties not provided in the structure
        self.topicId = UUID()
        self.presentations = 0
        self.dateLastPresented = nil
        self.progress = 0.0
    }
    
    private enum CodingKeys: String, CodingKey {
        case topicTitle, topicCategory, learningIndex, questions
    }
}
