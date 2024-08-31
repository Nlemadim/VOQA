//
//  Performance.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/16/24.
//

import Foundation
import SwiftUI

struct Performance: Identifiable, Hashable, Codable {
    let id: UUID
    let userID: String?
    let quizId: String?
    var quizTitle: String?
    var quizCategory: String? // New optional property
    var date: Date
    var score: CGFloat
    var numberOfQuestions: Int

    // Custom initializer to handle optional properties
    init(id: UUID = UUID(),
         userID: String? = nil,
         quizId: String? = nil,
         quizTitle: String? = nil,
         quizCategory: String? = nil, // Added quizCategory here
         date: Date,
         score: CGFloat,
         numberOfQuestions: Int) {
        self.id = id
        self.userID = userID
        self.quizId = quizId
        self.quizTitle = quizTitle
        self.quizCategory = quizCategory
        self.date = date
        self.score = score
        self.numberOfQuestions = numberOfQuestions
    }

    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        case quizId
        case quizTitle
        case quizCategory
        case date
        case score
        case numberOfQuestions
    }
}
