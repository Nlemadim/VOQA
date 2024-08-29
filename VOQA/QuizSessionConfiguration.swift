//
//  QuizSessionConfiguration.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/28/24.
//

import Foundation

struct QuizSessionConfig: Codable {
    var sessionId: UUID
    var sessionTitle: String
    var sessionVoice: String
    var sessionQuestion: [Question]
    var alerts: [AlertSfx]
    var controlFeedback: ControlsFeedback
    var quizFeedback: QuizFeedback
    var sessionMusic: [BgmSfx]
    var quizHostMessages: QuizSessionHostMessages? 

    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionTitle
        case sessionVoice
        case sessionQuestion
        case alerts
        case controlFeedback
        case quizFeedback
        case sessionMusic
        case quizHostMessages
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionId = (try? container.decode(UUID.self, forKey: .sessionId)) ?? UUID()
        sessionTitle = try container.decode(String.self, forKey: .sessionTitle)
        sessionVoice = try container.decode(String.self, forKey: .sessionVoice)
        sessionQuestion = try container.decode([Question].self, forKey: .sessionQuestion)
        alerts = try container.decode([AlertSfx].self, forKey: .alerts)
        controlFeedback = try container.decode(ControlsFeedback.self, forKey: .controlFeedback)
        quizFeedback = try container.decode(QuizFeedback.self, forKey: .quizFeedback)
        sessionMusic = try container.decode([BgmSfx].self, forKey: .sessionMusic)
        quizHostMessages = try? container.decode(QuizSessionHostMessages.self, forKey: .quizHostMessages) // Safely decoding optional property
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(sessionTitle, forKey: .sessionTitle)
        try container.encode(sessionVoice, forKey: .sessionVoice)
        try container.encode(sessionQuestion, forKey: .sessionQuestion)
        try container.encode(alerts, forKey: .alerts)
        try container.encode(controlFeedback, forKey: .controlFeedback)
        try container.encode(quizFeedback, forKey: .quizFeedback)
        try container.encode(sessionMusic, forKey: .sessionMusic)
        try container.encodeIfPresent(quizHostMessages, forKey: .quizHostMessages) // Encoding optional property only if present
    }
}
