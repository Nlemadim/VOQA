//
//  VoicedFeedbackType.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation

enum VoicedFeedbackType: Codable {
    case startQuiz(VoicedFeedback)
    case quit(VoicedFeedback)
    case nextQuestion(VoicedFeedback)
    case repeatQuestion(VoicedFeedback)
    case incorrectAnswer(VoicedFeedback)
    case correctAnswer(VoicedFeedback)
    case noResponse(VoicedFeedback)
    
    enum CodingKeys: String, CodingKey {
        case type
        case feedback
    }

    enum FeedbackType: String, Codable {
        case startQuiz
        case quit
        case nextQuestion
        case repeatQuestion
        case incorrectAnswer
        case correctAnswer
        case noResponse
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(FeedbackType.self, forKey: .type)
        
        switch type {
        case .startQuiz:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .startQuiz(feedback)
        case .quit:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .quit(feedback)
        case .nextQuestion:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .nextQuestion(feedback)
        case .repeatQuestion:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .repeatQuestion(feedback)
        case .incorrectAnswer:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .incorrectAnswer(feedback)
        case .correctAnswer:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .correctAnswer(feedback)
        case .noResponse:
            let feedback = try container.decode(VoicedFeedback.self, forKey: .feedback)
            self = .noResponse(feedback)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .startQuiz(let feedback):
            try container.encode(FeedbackType.startQuiz, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        case .quit(let feedback):
            try container.encode(FeedbackType.quit, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        case .nextQuestion(let feedback):
            try container.encode(FeedbackType.nextQuestion, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        case .repeatQuestion(let feedback):
            try container.encode(FeedbackType.repeatQuestion, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        case .incorrectAnswer(let feedback):
            try container.encode(FeedbackType.incorrectAnswer, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        case .correctAnswer(let feedback):
            try container.encode(FeedbackType.correctAnswer, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        case .noResponse(let feedback):
            try container.encode(FeedbackType.noResponse, forKey: .type)
            try container.encode(feedback, forKey: .feedback)
        }
    }
}



