//
//  QuizFeedback.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/23/24.
//

import Foundation

struct QuizFeedback: Codable, Hashable, Equatable {
    var incorrectAnswer: VoicedFeedback
    var correctAnswer: VoicedFeedback
    var noResponse: VoicedFeedback
    var review: VoicedFeedback
    
    enum CodingKeys: String, CodingKey {
        case incorrectAnswer
        case correctAnswer
        case noResponse
        case review
    }
    
    init(incorrectAnswer: VoicedFeedback, correctAnswer: VoicedFeedback, noResponse: VoicedFeedback, review: VoicedFeedback) {
        self.incorrectAnswer = incorrectAnswer
        self.correctAnswer = correctAnswer
        self.noResponse = noResponse
        self.review = review
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        incorrectAnswer = try container.decode(VoicedFeedback.self, forKey: .incorrectAnswer)
        correctAnswer = try container.decode(VoicedFeedback.self, forKey: .correctAnswer)
        noResponse = try container.decode(VoicedFeedback.self, forKey: .noResponse)
        review = try container.decode(VoicedFeedback.self, forKey: .review)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(incorrectAnswer, forKey: .incorrectAnswer)
        try container.encode(correctAnswer, forKey: .correctAnswer)
        try container.encode(noResponse, forKey: .noResponse)
        try container.encode(review, forKey: .review)
    }
    
    // MARK: - Equatable Conformance
    
    static func == (lhs: QuizFeedback, rhs: QuizFeedback) -> Bool {
        return lhs.incorrectAnswer == rhs.incorrectAnswer &&
        lhs.correctAnswer == rhs.correctAnswer &&
        lhs.noResponse == rhs.noResponse &&
        lhs.review == rhs.review
    }
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(incorrectAnswer)
        hasher.combine(correctAnswer)
        hasher.combine(noResponse)
        hasher.combine(review)
    }
}
