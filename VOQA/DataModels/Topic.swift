//
//  Topic.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class Topic {
    @Attribute(.unique) var topicId: UUID
    var topicTitle: String
    @Relationship(deleteRule: .cascade) var customQuizPackage: CustomQuizPackage?
    @Relationship(deleteRule: .cascade) var standardQuizPackage: StandardQuizPackage?
    var topicCategory: TopicCategory
    var presentations: Int
    var dateLastPresented: Date? // Optional
    @Relationship(deleteRule: .cascade) var questions: [Question] = []

    init(topicId: UUID = UUID(), topicTitle: String, customQuizPackage: CustomQuizPackage? = nil, standardQuizPackage: StandardQuizPackage? = nil, topicCategory: TopicCategory, presentations: Int = 0, dateLastPresented: Date? = nil) {
        self.topicId = topicId
        self.topicTitle = topicTitle
        self.customQuizPackage = customQuizPackage
        self.standardQuizPackage = standardQuizPackage
        self.topicCategory = topicCategory
        self.presentations = presentations
        self.dateLastPresented = dateLastPresented
    }
}














