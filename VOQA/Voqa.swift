//
//  Voqa.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/22/24.
//

import Foundation
import SwiftUI

struct Voqa: Identifiable, Hashable, Decodable {
    var id: String
    var quizTitle: String
    var acronym: String
    var about: String
    var imageUrl: String
    var rating: Int = 0  // Default value
    var curator: String = ""  // Default value
    var users: Int = 0  // Default value
    var tags: [String] = []  // Default value
    var colors: ThemeColors
    var ratings: Int = 0  // Default value
    var requiresSubscription: Bool = false  // Default value
    
    private enum CodingKeys: String, CodingKey {
        case id, quizTitle, acronym, about, imageUrl, rating, curator, users, tags, colors, ratings, requiresSubscription
    }
    // Custom initializer
    init(
        id: String,
        quizTitle: String,
        acronym: String,
        about: String,
        imageUrl: String,
        rating: Int,
        curator: String,
        users: Int,
        tags: [String],
        colors: ThemeColors,
        ratings: Int,
        requiresSubscription: Bool
    ) {
        self.id = id
        self.quizTitle = quizTitle
        self.acronym = acronym
        self.about = about
        self.imageUrl = imageUrl
        self.rating = rating
        self.curator = curator
        self.users = users
        self.tags = tags
        self.colors = colors
        self.ratings = ratings
        self.requiresSubscription = requiresSubscription
    }
    
    // Decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.quizTitle = try container.decode(String.self, forKey: .quizTitle)
        self.acronym = try container.decode(String.self, forKey: .acronym)
        self.about = try container.decode(String.self, forKey: .about)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.rating = try container.decode(Int.self, forKey: .rating)
        self.curator = try container.decode(String.self, forKey: .curator)
        self.users = try container.decode(Int.self, forKey: .users)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.colors = try container.decode(ThemeColors.self, forKey: .colors)
        self.ratings = try container.decode(Int.self, forKey: .ratings)
        self.requiresSubscription = try container.decode(Bool.self, forKey: .requiresSubscription)
    }
    
    // Initializer from QuizData
    init(from quizData: QuizData) {
        self.id = quizData.id
        self.quizTitle = quizData.quizTitle
        self.acronym = quizData.acronym ?? ""
        self.about = quizData.about
        self.imageUrl = quizData.imageUrl
        self.rating = quizData.ratings
        self.curator = quizData.curator ?? ""
        self.users = quizData.users
        self.tags = quizData.tags
        self.colors = quizData.colors
        self.ratings = quizData.ratings
        self.requiresSubscription = quizData.requiresSubscription
    }
    
    // Conforming to Hashable protocol
    static func == (lhs: Voqa, rhs: Voqa) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Voqa: VoqaItem {
    // Initializer from VoqaItem
    init(from item: VoqaItem, id: String) {
        self.id = id
        self.quizTitle = item.quizTitle
        self.acronym = item.acronym
        self.about = item.about
        self.imageUrl = item.imageUrl
        self.colors = item.colors
        // Other properties will use their default values
    }
}
