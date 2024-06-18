//
//  QuizCategories.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

enum QuizCategories: String, Codable, Identifiable, CaseIterable, Hashable {
    case science = "Science"
    case technology = "Technology"
    case healthcare = "Healthcare"
    case legal = "Legal"
    case business = "Business"
    case itCertifications = "Information Technology"
    case professional = "Proffesional"
    case language = "Language"
    case engineering = "Engineering"
    case finance = "Finance"
    case miscellaneous = "Education"
    case education = "Educational"
    case topColledgePicks = "Colledge"
    case topProfessionalCertification = "Profesional Certification"
    case history = "History"
    case free = "Free"
    case topCollection = "Top Picks"
    case cultureAndSociety = "Culture and Society"
    case funFacts = "Fun Facts"
    

    var id: Self { self }

    var descr: String {
        switch self {
        case .science:
            return "Science"
        case .technology:
            return "Technology"
        case .healthcare:
            return "Healthcare"
        case .legal:
            return "Legal"
        case .business:
            return "Business"
        case .itCertifications:
            return "Information Technology"
        case .professional:
            return "Professional"
        case .language:
            return "Language"
        case .engineering:
            return "Engineering"
        case .finance:
            return "Finance"
        case .miscellaneous:
            return "Miscellaneous"
        case .education:
            return "Educational"
        case .topColledgePicks:
            return "Colledge"
        case .topProfessionalCertification:
            return "Profesional Certification"
        case .history:
            return "History"
        case .free:
            return "Sponsored"//Location Based Quizzes. For promoting communities, Activities within location
        case .topCollection:
            return "Top Picks"
        case .cultureAndSociety:
            return "Culture and Society"
        case .funFacts:
            return "Fun Facts"
        }
    }
}

struct CombinedCategory: Hashable {
    let name: String
    let includedCategories: [QuizCategories]

    static func ==(lhs: CombinedCategory, rhs: CombinedCategory) -> Bool {
        return lhs.name == rhs.name && lhs.includedCategories == rhs.includedCategories
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(includedCategories)
    }
}

let combinedCategories: [CombinedCategory] = [
    CombinedCategory(name: "Top Picks", includedCategories: [.technology, .healthcare, .science]),
    CombinedCategory(name: "Free", includedCategories: [.education, .language]),
    CombinedCategory(name: "Colledge Picks", includedCategories: [.healthcare, .language]),
    CombinedCategory(name: "Science", includedCategories: [.healthcare, .engineering, .professional])
    
]

enum GroupedCategory {
    case topPicks
    case free

    var title: String {
        switch self {
        case .topPicks: return "Top Picks"
        case .free: return "Free"
        }
    }

    var includedCategories: [QuizCategories] {
        switch self {
        case .topPicks: return [.legal, .healthcare, .science]
        case .free: return [.healthcare]
        }
    }
}

enum UnifiedCategory: Identifiable {
    case individual(QuizCategories)
    case grouped(GroupedCategory)

    var id: String {
        switch self {
        case .individual(let category):
            return category.rawValue
        case .grouped(let grouped):
            return grouped.title
        }
    }

    var title: String {
        switch self {
        case .individual(let category):
            return category.rawValue
        case .grouped(let grouped):
            return grouped.title
        }
    }
}


