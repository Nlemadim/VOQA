//
//  AudioQuiz.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class AudioQuiz {
    @Attribute(.unique) var id: UUID
    var quizTitle: String
    var titleImage: String
    var shortTitle: String = "VOQA"
    var firstStarted: Date
    var completions: Int
    var userHighScore: Int
    var ratings: Int
    @Relationship(deleteRule: .cascade) var customQuizPackage: CustomQuizPackage?
    @Relationship(deleteRule: .cascade) var standardQuizPackage: StandardQuizPackage?
    @Relationship(deleteRule: .cascade) var currentQuizTopics: [Topic] = []

    init(id: UUID = UUID(), quizTitle: String, titleImage: String, completions: Int = 0, userHighScore: Int = 0, ratings: Int = 0, currentQuizTopics: [Topic] = [], customQuizPackage: CustomQuizPackage? = nil, standardQuizPackage: StandardQuizPackage? = nil) {
        self.id = id
        self.quizTitle = quizTitle
        self.titleImage = titleImage
        self.shortTitle = "VOQA"
        self.firstStarted = .now
        self.completions = completions
        self.userHighScore = userHighScore
        self.ratings = ratings
        self.currentQuizTopics = currentQuizTopics
        self.customQuizPackage = customQuizPackage
        self.standardQuizPackage = standardQuizPackage
    }

    convenience init(quizTitle: String, titleImage: String) {
        self.init(quizTitle: quizTitle, titleImage: titleImage, completions: 0, userHighScore: 0, ratings: 0, currentQuizTopics: [], customQuizPackage: nil, standardQuizPackage: nil)
    }
}
