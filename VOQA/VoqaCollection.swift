//
//  VoqaCollection.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//

import Foundation
import SwiftUI

struct VoqaCollection: VoqaConfiguration, Identifiable, Decodable {
    var id: UUID = UUID()
    var category: String
    var subtitle: String
    var quizzes: [Voqa]
    
    private enum CodingKeys: String, CodingKey {
        case category, subtitle, quizzes
    }
}

struct VoqaConfig: Decodable {
    var voqaCollection: [VoqaCollection]
}

struct Colors: Decodable {
    var main: String
    var sub: String
    var third: String
}

struct Voqa: VoqaItem, Identifiable, Hashable, Decodable {
    var id: String  // Changed to String to match JSON structure
    var quizTitle: String
    var acronym: String
    var about: String
    var imageUrl: String
    var rating: Int
    var curator: String
    var users: Int
    var title: String
    var titleImage: String
    var categories: [String]
    var colors: Colors
    var ratings: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, quizTitle, acronym, about, imageUrl, rating, curator, users, title, titleImage, categories, colors, ratings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)  // Decoding as String
        self.quizTitle = try container.decode(String.self, forKey: .quizTitle)
        self.acronym = try container.decode(String.self, forKey: .acronym)
        self.about = try container.decode(String.self, forKey: .about)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.rating = try container.decode(Int.self, forKey: .rating)
        self.curator = try container.decode(String.self, forKey: .curator)
        self.users = try container.decode(Int.self, forKey: .users)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.titleImage = try container.decodeIfPresent(String.self, forKey: .titleImage) ?? ""
        self.categories = try container.decodeIfPresent([String].self, forKey: .categories) ?? []
        self.colors = try container.decodeIfPresent(Colors.self, forKey: .colors) ?? Colors(main: "", sub: "", third: "")
        self.ratings = try container.decodeIfPresent(Int.self, forKey: .ratings) ?? 0
    }
    
    init(
        id: String,  // Updated to String
        quizTitle: String,
        acronym: String,
        about: String,
        imageUrl: String,
        rating: Int = 0,
        curator: String = "",
        users: Int = 0,
        title: String = "",
        titleImage: String = "",
        categories: [String] = [],
        colors: Colors = Colors(main: "", sub: "", third: ""),
        ratings: Int = 0
    ) {
        self.id = id
        self.quizTitle = quizTitle
        self.acronym = acronym
        self.about = about
        self.imageUrl = imageUrl
        self.rating = rating
        self.curator = curator
        self.users = users
        self.title = title
        self.titleImage = titleImage
        self.categories = categories
        self.colors = colors
        self.ratings = ratings
    }
    
    // Conforming to Hashable protocol
    static func == (lhs: Voqa, rhs: Voqa) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
