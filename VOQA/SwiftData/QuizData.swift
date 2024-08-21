//
//  QuizData.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/20/24.
//

import Foundation
import SwiftUI

struct QuizDataStruct: Decodable {
    var id: String
    var coreTopics: [String]
    var about: String
    var generalTopics: [String]
    var quizTitle: String
    var imageUrl: String
    var colors: Colors
    var curator: String?
    var ratings: Int
    var users: Int
    var catalogueGroup: String?
    var acronym: String?

    struct Colors: Decodable {
        var main: String
        var sub: String
        var third: String
    }
    
    // Custom initializer for manual instantiation
    init(id: String, coreTopics: [String], about: String, generalTopics: [String], quizTitle: String, imageUrl: String, colors: Colors, curator: String?, ratings: Int, users: Int, catalogueGroup: String?, acronym: String?) {
        self.id = id
        self.coreTopics = coreTopics
        self.about = about
        self.generalTopics = generalTopics
        self.quizTitle = quizTitle
        self.imageUrl = imageUrl
        self.colors = colors
        self.curator = curator
        self.ratings = ratings
        self.users = users
        self.catalogueGroup = catalogueGroup
        self.acronym = acronym
    }
    
    // Existing decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.about = try container.decode(String.self, forKey: .about)
        self.quizTitle = try container.decode(String.self, forKey: .quizTitle)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.colors = try container.decode(Colors.self, forKey: .colors)
        self.curator = try container.decodeIfPresent(String.self, forKey: .curator)
        self.ratings = try container.decodeIfPresent(Int.self, forKey: .ratings) ?? 0
        self.users = try container.decodeIfPresent(Int.self, forKey: .users) ?? 0
        self.catalogueGroup = try container.decodeIfPresent(String.self, forKey: .catalogueGroup)
        self.acronym = try container.decodeIfPresent(String.self, forKey: .acronym)
        
        // Decode coreTopics and generalTopics as dictionaries, then convert to arrays
        let coreTopicsDict = try container.decode([String: String].self, forKey: .coreTopics)
        self.coreTopics = coreTopicsDict.values.sorted() // Sorting to maintain order
        
        let generalTopicsDict = try container.decode([String: String].self, forKey: .generalTopics)
        self.generalTopics = generalTopicsDict.values.sorted() // Sorting to maintain order
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, coreTopics, about, generalTopics, quizTitle, imageUrl, colors, curator, ratings, users, catalogueGroup, acronym
    }
}


struct QuizCatalogueData {
    var categoryName: String
    var quizzes: [QuizDataStruct]
}
