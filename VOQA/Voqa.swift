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
    var rating: Int
    var curator: String
    var users: Int
    var tags: [String]
    var colors: ThemeColors
    var ratings: Int
    var requiresSubscription: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id, quizTitle, acronym, about, imageUrl, rating, curator, users, tags, colors, ratings, requiresSubscription
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
