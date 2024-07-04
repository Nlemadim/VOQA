//
//  StandardQuizPackage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
final class StandardQuizPackage: Decodable, Identifiable {
    
    var title: String
    var summaryDesc: String
    var shortTitle: String
    var firstStarted: Date
    var completions: Int
    
    @Attribute(.externalStorage)
    var titleImage: Data?
    
    @Attribute(.unique) var id: UUID
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

    init(id: UUID = UUID(), title: String, titleImage: Data? = nil, summaryDesc: String, shortTitle: String = "", firstStarted: Date = Date(), completions: Int = 0, topics: [Topic] = [], themeColors: [Int] = [], rating: Int? = nil, numberOfRatings: Int? = nil, edition: PackageEdition, curator: String? = nil, users: Int? = nil, category: [QuizCategories] = [], audioQuiz: AudioQuiz? = nil, performance: [Performance] = []) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.summaryDesc = summaryDesc
        self.shortTitle = shortTitle
        self.firstStarted = firstStarted
        self.completions = completions
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

    convenience init(id: UUID, title: String, titleImage: Data? = nil) {
        self.init(id: id, title: title, titleImage: titleImage, summaryDesc: "N/A", edition: .basic)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        titleImage = try container.decode(Data?.self, forKey: .titleImage)
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
        shortTitle = try container.decode(String.self, forKey: .shortTitle)
        firstStarted = try container.decode(Date.self, forKey: .firstStarted)
        completions = try container.decode(Int.self, forKey: .completions)
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
        case shortTitle
        case firstStarted
        case completions
    }
}
