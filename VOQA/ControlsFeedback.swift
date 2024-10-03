//
//  ControlsFeedback.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/23/24.
//

import Foundation

struct ControlsFeedback: Codable, Hashable, Equatable {
    var startQuiz: VoicedFeedback
    var nextQuestion: VoicedFeedback
    var repeatQuestion: VoicedFeedback
    
    enum CodingKeys: String, CodingKey {
        case startQuiz
        case nextQuestion
        case repeatQuestion
    }
    
    init(startQuiz: VoicedFeedback, nextQuestion: VoicedFeedback, repeatQuestion: VoicedFeedback) {
        self.startQuiz = startQuiz
        self.nextQuestion = nextQuestion
        self.repeatQuestion = repeatQuestion
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startQuiz = try container.decode(VoicedFeedback.self, forKey: .startQuiz)
        nextQuestion = try container.decode(VoicedFeedback.self, forKey: .nextQuestion)
        repeatQuestion = try container.decode(VoicedFeedback.self, forKey: .repeatQuestion)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startQuiz, forKey: .startQuiz)
        try container.encode(nextQuestion, forKey: .nextQuestion)
        try container.encode(repeatQuestion, forKey: .repeatQuestion)
    }
    
    // MARK: - Equatable Conformance
    
    static func == (lhs: ControlsFeedback, rhs: ControlsFeedback) -> Bool {
        return lhs.startQuiz == rhs.startQuiz &&
        lhs.nextQuestion == rhs.nextQuestion &&
        lhs.repeatQuestion == rhs.repeatQuestion
    }
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startQuiz)
        hasher.combine(nextQuestion)
        hasher.combine(repeatQuestion)
    }
}
