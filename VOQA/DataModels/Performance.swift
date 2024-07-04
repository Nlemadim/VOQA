//
//  Performance.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class Performance: Identifiable, Hashable, Decodable {
    let id: UUID
    var quizName: String
    var date: Date
    var score: CGFloat
    var numberOfQuestions: Int
    
    init(id: UUID = UUID(), quizName: String, date: Date, score: CGFloat, numberOfQuestions: Int) {
        self.id = id
        self.quizName = quizName
        self.date = date
        self.score = score
        self.numberOfQuestions = numberOfQuestions
    }

    // Decodable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        quizName = try container.decode(String.self, forKey: .quizName)
        date = try container.decode(Date.self, forKey: .date)
        score = try container.decode(CGFloat.self, forKey: .score)
        numberOfQuestions = try container.decode(Int.self, forKey: .numberOfQuestions)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case quizName
        case date
        case score
        case numberOfQuestions
    }

    // Hashable conformance
    static func == (lhs: Performance, rhs: Performance) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
