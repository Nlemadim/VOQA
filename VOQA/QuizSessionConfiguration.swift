//
//  QuizSessionConfiguration.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/28/24.
//

import Foundation
import Combine

final class QuizSessionConfig: ObservableObject, Codable, Hashable, Equatable {
    // MARK: - Published Properties
    @Published var sessionQuestion: [Question] = []
    
    // MARK: - Properties
    var sessionId: UUID
    var sessionTitle: String
    var sessionVoice: String
    var sessionVoiceId: String? // New optional property
    var alerts: [AlertSfx]
    var controlFeedback: ControlsFeedback
    var quizFeedback: QuizFeedback
    var sessionMusic: [BgmSfx]
    var quizHostMessages: QuizSessionHostMessages?
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionTitle
        case sessionVoice
        case sessionVoiceId  // Added sessionVoiceId to the coding keys
        case sessionQuestion
        case alerts
        case controlFeedback
        case quizFeedback
        case sessionMusic
        case quizHostMessages
    }
    
    // MARK: - Initializers
    init(
        sessionId: UUID,
        sessionTitle: String,
        sessionVoice: String,
        sessionVoiceId: String?,  
        sessionQuestion: [Question],
        alerts: [AlertSfx],
        controlFeedback: ControlsFeedback,
        quizFeedback: QuizFeedback,
        sessionMusic: [BgmSfx],
        quizHostMessages: QuizSessionHostMessages?
    ) {
        self.sessionId = UUID()
        self.sessionTitle = sessionTitle
        self.sessionVoice = sessionVoice
        self.sessionVoiceId = sessionVoiceId  // Initialize the new property
        self.sessionQuestion = sessionQuestion
        self.alerts = alerts
        self.controlFeedback = controlFeedback
        self.quizFeedback = quizFeedback
        self.sessionMusic = sessionMusic
        self.quizHostMessages = quizHostMessages
    }
    
    // MARK: - Codable Conformance
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sessionId = (try? container.decode(UUID.self, forKey: .sessionId)) ?? UUID()
        let sessionTitle = try container.decode(String.self, forKey: .sessionTitle)
        let sessionVoice = try container.decode(String.self, forKey: .sessionVoice)
        let sessionVoiceId = try? container.decode(String?.self, forKey: .sessionVoiceId) // Decode the new property
        let sessionQuestion = try container.decode([Question].self, forKey: .sessionQuestion)
        let alerts = try container.decode([AlertSfx].self, forKey: .alerts)
        let controlFeedback = try container.decode(ControlsFeedback.self, forKey: .controlFeedback)
        let quizFeedback = try container.decode(QuizFeedback.self, forKey: .quizFeedback)
        let sessionMusic = try container.decode([BgmSfx].self, forKey: .sessionMusic)
        let quizHostMessages = try? container.decode(QuizSessionHostMessages.self, forKey: .quizHostMessages)
        
        self.init(
            sessionId: sessionId,
            sessionTitle: sessionTitle,
            sessionVoice: sessionVoice,
            sessionVoiceId: sessionVoiceId, // Pass the new property
            sessionQuestion: sessionQuestion,
            alerts: alerts,
            controlFeedback: controlFeedback,
            quizFeedback: quizFeedback,
            sessionMusic: sessionMusic,
            quizHostMessages: quizHostMessages
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(sessionTitle, forKey: .sessionTitle)
        try container.encode(sessionVoice, forKey: .sessionVoice)
        try container.encodeIfPresent(sessionVoiceId, forKey: .sessionVoiceId) // Encode the new property
        try container.encode(sessionQuestion, forKey: .sessionQuestion)
        try container.encode(alerts, forKey: .alerts)
        try container.encode(controlFeedback, forKey: .controlFeedback)
        try container.encode(quizFeedback, forKey: .quizFeedback)
        try container.encode(sessionMusic, forKey: .sessionMusic)
        try container.encodeIfPresent(quizHostMessages, forKey: .quizHostMessages)
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: QuizSessionConfig, rhs: QuizSessionConfig) -> Bool {
        return lhs.sessionId == rhs.sessionId &&
               lhs.sessionTitle == rhs.sessionTitle &&
               lhs.sessionVoice == rhs.sessionVoice &&
               lhs.sessionVoiceId == rhs.sessionVoiceId && // Added new property check
               lhs.sessionQuestion == rhs.sessionQuestion &&
               lhs.alerts == rhs.alerts &&
               lhs.controlFeedback == rhs.controlFeedback &&
               lhs.quizFeedback == rhs.quizFeedback &&
               lhs.sessionMusic == rhs.sessionMusic &&
               lhs.quizHostMessages == rhs.quizHostMessages
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(sessionId)
        hasher.combine(sessionTitle)
        hasher.combine(sessionVoice)
        hasher.combine(sessionVoiceId) // Hash the new property
        hasher.combine(sessionQuestion)
        hasher.combine(alerts)
        hasher.combine(controlFeedback)
        hasher.combine(quizFeedback)
        hasher.combine(sessionMusic)
        hasher.combine(quizHostMessages)
    }
}
