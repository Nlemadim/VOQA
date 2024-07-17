//
//  QuizDataModels.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation

struct FeedbackSfx: Codable {
    var title: String
    var urlScript: String
    var audioUrl: String
}

struct BgmSfx: Codable {
    var title: String
    var audioUrl: String
}

struct AlertSfx: Codable {
    var title: String
    var urlScript: String
    var audioUrl: String
}

struct VoicedFeedback: Codable {
    var title: String
    var audioUrls: [FeedbackSfx]

    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }

    init(title: String, audioUrls: [FeedbackSfx]) {
        self.title = title
        self.audioUrls = audioUrls
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        audioUrls = try container.decode([FeedbackSfx].self, forKey: .audioUrls)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(audioUrls, forKey: .audioUrls)
    }

    func clone(with audioUrls: [FeedbackSfx]) -> VoicedFeedback {
        return VoicedFeedback(title: self.title, audioUrls: audioUrls)
    }
}

struct ControlsFeedback: Codable {
    var startQuiz: VoicedFeedback
    var quit: VoicedFeedback
    var nextQuestion: VoicedFeedback
    var repeatQuestion: VoicedFeedback

    enum CodingKeys: String, CodingKey {
        case startQuiz
        case quit
        case nextQuestion
        case repeatQuestion
    }
    
    init(startQuiz: VoicedFeedback, quit: VoicedFeedback, nextQuestion: VoicedFeedback, repeatQuestion: VoicedFeedback) {
        self.startQuiz = startQuiz
        self.quit = quit
        self.nextQuestion = nextQuestion
        self.repeatQuestion = repeatQuestion
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startQuiz = try container.decode(VoicedFeedback.self, forKey: .startQuiz)
        quit = try container.decode(VoicedFeedback.self, forKey: .quit)
        nextQuestion = try container.decode(VoicedFeedback.self, forKey: .nextQuestion)
        repeatQuestion = try container.decode(VoicedFeedback.self, forKey: .repeatQuestion)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startQuiz, forKey: .startQuiz)
        try container.encode(quit, forKey: .quit)
        try container.encode(nextQuestion, forKey: .nextQuestion)
        try container.encode(repeatQuestion, forKey: .repeatQuestion)
    }
}

struct QuizFeedback: Codable {
    var incorrectAnswer: VoicedFeedback
    var correctAnswer: VoicedFeedback
    var noResponse: VoicedFeedback

    enum CodingKeys: String, CodingKey {
        case incorrectAnswer
        case correctAnswer
        case noResponse
    }
    
    init(incorrectAnswer: VoicedFeedback, correctAnswer: VoicedFeedback, noResponse: VoicedFeedback) {
        self.incorrectAnswer = incorrectAnswer
        self.correctAnswer = correctAnswer
        self.noResponse = noResponse
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        incorrectAnswer = try container.decode(VoicedFeedback.self, forKey: .incorrectAnswer)
        correctAnswer = try container.decode(VoicedFeedback.self, forKey: .correctAnswer)
        noResponse = try container.decode(VoicedFeedback.self, forKey: .noResponse)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(incorrectAnswer, forKey: .incorrectAnswer)
        try container.encode(correctAnswer, forKey: .correctAnswer)
        try container.encode(noResponse, forKey: .noResponse)
    }
}

struct QuizSessionConfig: Codable {
    var sessionId: UUID
    var sessionTitle: String
    var sessionVoice: String
    var sessionQuestion: [Question]
    var alerts: [AlertSfx]
    var controlFeedback: ControlsFeedback
    var quizFeedback: QuizFeedback
    var sessionMusic: [BgmSfx]

    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionTitle
        case sessionVoice
        case sessionQuestion
        case alerts
        case controlFeedback
        case quizFeedback
        case sessionMusic
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
    }
}

struct Question: Codable {
    var id: UUID
    var content: String
    var options: [String]
    var correctOption: String
    var selectedOption: String?
    var overview: String
    var isAnswered: Bool
    var isAnsweredCorrectly: Bool
    var numberOfPresentations: Int
    var audioScript: String
    var audioUrl: String
    var overviewUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case options
        case correctOption
        case selectedOption
        case overview
        case isAnswered
        case isAnsweredCorrectly
        case numberOfPresentations
        case audioScript
        case audioUrl
        case overviewUrl
    }
}
