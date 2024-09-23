//
//  QuizSessionHostMessages.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/23/24.
//

import Foundation

struct QuizSessionHostMessages: Codable, Hashable, Equatable {
    var hostNarratorIntro: VoicedFeedback
    var quizSessionIntro: VoicedFeedback
    var messageFromSponsor: VoicedFeedback
    var resumeFromSponsoredMessage: VoicedFeedback
    var prepareForReview: VoicedFeedback
    var resumeFromReview: VoicedFeedback
    var sponsoredOutroMessage: VoicedFeedback
    var outro: VoicedFeedback

    enum CodingKeys: String, CodingKey {
        case hostNarratorIntro
        case quizSessionIntro
        case messageFromSponsor
        case resumeFromSponsoredMessage
        case prepareForReview
        case resumeFromReview
        case sponsoredOutroMessage
        case outro
    }

    init(
        hostNarratorIntro: VoicedFeedback,
        quizSessionIntro: VoicedFeedback,
        messageFromSponsor: VoicedFeedback,
        resumeFromSponsoredMessage: VoicedFeedback,
        prepareForReview: VoicedFeedback,
        resumeFromReview: VoicedFeedback,
        sponsoredOutroMessage: VoicedFeedback,
        outro: VoicedFeedback
    ) {
        self.hostNarratorIntro = hostNarratorIntro
        self.quizSessionIntro = quizSessionIntro
        self.messageFromSponsor = messageFromSponsor
        self.resumeFromSponsoredMessage = resumeFromSponsoredMessage
        self.prepareForReview = prepareForReview
        self.resumeFromReview = resumeFromReview
        self.sponsoredOutroMessage = sponsoredOutroMessage
        self.outro = outro
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hostNarratorIntro = try container.decode(VoicedFeedback.self, forKey: .hostNarratorIntro)
        quizSessionIntro = try container.decode(VoicedFeedback.self, forKey: .quizSessionIntro)
        messageFromSponsor = try container.decode(VoicedFeedback.self, forKey: .messageFromSponsor)
        resumeFromSponsoredMessage = try container.decode(VoicedFeedback.self, forKey: .resumeFromSponsoredMessage)
        prepareForReview = try container.decode(VoicedFeedback.self, forKey: .prepareForReview)
        resumeFromReview = try container.decode(VoicedFeedback.self, forKey: .resumeFromReview)
        sponsoredOutroMessage = try container.decode(VoicedFeedback.self, forKey: .sponsoredOutroMessage)
        outro = try container.decode(VoicedFeedback.self, forKey: .outro)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hostNarratorIntro, forKey: .hostNarratorIntro)
        try container.encode(quizSessionIntro, forKey: .quizSessionIntro)
        try container.encode(messageFromSponsor, forKey: .messageFromSponsor)
        try container.encode(resumeFromSponsoredMessage, forKey: .resumeFromSponsoredMessage)
        try container.encode(prepareForReview, forKey: .prepareForReview)
        try container.encode(resumeFromReview, forKey: .resumeFromReview)
        try container.encode(sponsoredOutroMessage, forKey: .sponsoredOutroMessage)
        try container.encode(outro, forKey: .outro)
    }

    // MARK: - Equatable Conformance

    static func == (lhs: QuizSessionHostMessages, rhs: QuizSessionHostMessages) -> Bool {
        return lhs.hostNarratorIntro == rhs.hostNarratorIntro &&
               lhs.quizSessionIntro == rhs.quizSessionIntro &&
               lhs.messageFromSponsor == rhs.messageFromSponsor &&
               lhs.resumeFromSponsoredMessage == rhs.resumeFromSponsoredMessage &&
               lhs.prepareForReview == rhs.prepareForReview &&
               lhs.resumeFromReview == rhs.resumeFromReview &&
               lhs.sponsoredOutroMessage == rhs.sponsoredOutroMessage &&
               lhs.outro == rhs.outro
    }

    // MARK: - Hashable Conformance

    func hash(into hasher: inout Hasher) {
        hasher.combine(hostNarratorIntro)
        hasher.combine(quizSessionIntro)
        hasher.combine(messageFromSponsor)
        hasher.combine(resumeFromSponsoredMessage)
        hasher.combine(prepareForReview)
        hasher.combine(resumeFromReview)
        hasher.combine(sponsoredOutroMessage)
        hasher.combine(outro)
    }
}
