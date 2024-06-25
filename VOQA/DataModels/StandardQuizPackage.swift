//
//  StandardQuizPackage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class StandardQuizPackage: QuizPackage, QuizPackageProtocol, Decodable {
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

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        titleImage = try container.decode(String.self, forKey: .titleImage)
        summaryDesc = try container.decode(String.self, forKey: .summaryDesc)
        topics = try container.decode([Topic].self, forKey: .topics)
        themeColors = try container.decode([Int].self, forKey: .themeColors)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        numberOfRatings = try container.decodeIfPresent(Int.self, forKey: .numberOfRatings)
        edition = try container.decode(PackageEdition.self, forKey: .edition)
        curator = try container.decodeIfPresent(String.self, forKey: .curator)
        users = try container.decodeIfPresent(Int.self, forKey: .users)
        category = try container.decode([QuizCategories].self, forKey: .category)
        performance = try container.decode([Performance].self, forKey: .performance)
        audioQuiz = try container.decodeIfPresent(AudioQuiz.self, forKey: .audioQuiz)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleImage
        case summaryDesc
        case topics
        case themeColors
        case rating
        case numberOfRatings
        case edition
        case curator
        case users
        case category
        case performance
        case audioQuiz
    }
}
