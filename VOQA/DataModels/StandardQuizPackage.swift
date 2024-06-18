//
//  StandardQuizPackage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData


@Model
class StandardQuizPackage: QuizPackage {
    @Attribute(.unique) var id: UUID
    var title: String
    var titleImage: String
    var summaryDesc: String
    @Relationship(deleteRule: .cascade) var topics: [Topic]
    var themeColors: [Int]
    var rating: Int?
    var numberOfRatings: Int?
    var edition: PackageEdition
    var curator: String?
    var users: Int?
    var category: [QuizCategories]
    @Relationship(deleteRule: .cascade) var audioQuiz: AudioQuiz?
    @Relationship(deleteRule: .cascade) var performance: [Performance] = []
    
    init(id: UUID = UUID(), title: String, titleImage: String, summaryDesc: String, topics: [Topic] = [], themeColors: [Int] = [], rating: Int? = nil, numberOfRatings: Int? = nil, edition: PackageEdition, curator: String? = nil, users: Int? = nil, category: [QuizCategories] = [], audioQuiz: AudioQuiz? = nil, performance: [Performance] = []) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.summaryDesc = summaryDesc
        self.topics = topics
        self.themeColors = themeColors
        self.rating = rating
        self.numberOfRatings = numberOfRatings
        self.edition = edition
        self.curator = curator
        self.users = users
        self.category = category
        self.audioQuiz = audioQuiz
        self.performance = performance
    }
    
    convenience init(id: UUID) {
        self.init(id: id, title: "VOQA", titleImage: "defaultImage.png", summaryDesc: "N/A", edition: .basic)
    }
    
    convenience init(id: UUID, name: String, imageUrl: String) {
        self.init(id: id, title: name, titleImage: imageUrl, summaryDesc: "N/A", edition: .basic)
    }
    
    convenience init(id: UUID, name: String, imageUrl: String, category: [QuizCategories]) {
        self.init(id: id, title: name, titleImage: imageUrl, summaryDesc: "N/A", edition: .basic, category: category)
    }
    
    convenience init(id: UUID, name: String, about: String, imageUrl: String, category: [QuizCategories]) {
        self.init(id: id, title: name, titleImage: imageUrl, summaryDesc: about, edition: .basic, category: category)
    }
}
