//
//  QuizSessionConfig.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//

import Foundation

protocol VoicedFeedback: Codable {
    var title: String { get }
    var audioUrls: [FeedbackSfx] { get set }
}

struct FeedbackSfx: Codable {
    var title: String
    var urlScript: String
    var audioUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case urlScript
        case audioUrl
    }
}

struct BgmSfx: Codable {
    var title: String
    var audioUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrl
    }
}

struct QuizSessionConfig: Codable {
    var seesionId: UUID
    var sessionTitle: String
    var sessionVoice: String
    var sessionQuestion: [Question]
    var alerts: [AlertSfx]
    var controlFeedback: ControlsFeedback
    var quizFeedback: QuizFeedback
    var sessionMusic: [BgmSfx]

    enum CodingKeys: String, CodingKey {
        case seesionId
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
        seesionId = (try? container.decode(UUID.self, forKey: .seesionId)) ?? UUID()
        sessionTitle = try container.decode(String.self, forKey: .sessionTitle)
        sessionVoice = try container.decode(String.self, forKey: .sessionVoice)
        sessionQuestion = try container.decode([Question].self, forKey: .sessionQuestion)
        alerts = try container.decode([AlertSfx].self, forKey: .alerts)
        controlFeedback = try container.decode(ControlsFeedback.self, forKey: .controlFeedback)
        quizFeedback = try container.decode(QuizFeedback.self, forKey: .quizFeedback)
        sessionMusic = try container.decode([BgmSfx].self, forKey: .sessionMusic)
    }
}

struct AlertSfx: Codable {
    var title: String
    var urlScript: String
    var audioUrl: String

    enum CodingKeys: String, CodingKey {
        case title
        case urlScript
        case audioUrl
    }
}

struct ControlsFeedback: Codable {
    var startQuiz: StartQuizFeedback
    var quit: QuitQuiz
    var nextQuestion: NextQuestion
    var repeatQuestioon: RepeatQuestion
    
    enum CodingKeys: String, CodingKey {
        case startQuiz
        case quit
        case nextQuestion
        case repeatQuestioon
    }
}

struct QuizFeedback: Codable {
    var incorrectAnswer: IncorrectAnswerFeedback
    var correctAnswer: CorrectAnswerFeedback
    var noResponse: NoResponseFeedback
    
    enum CodingKeys: String, CodingKey {
        case incorrectAnswer
        case correctAnswer
        case noResponse
    }
}

struct StartQuizFeedback: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct QuitQuiz: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct NextQuestion: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct RepeatQuestion: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct IncorrectAnswerFeedback: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct CorrectAnswerFeedback: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct NoResponseFeedback: VoicedFeedback {
    var title: String
    var audioUrls: [FeedbackSfx]
    
    enum CodingKeys: String, CodingKey {
        case title
        case audioUrls
    }
}

struct Question: Codable {
    var id: UUID
    var content: String
    var options: [String]
    var correctOption: String
    var selectedOption: String
    var isAnswered: Bool
    var isAnsweredCorrectly: Bool
    var numberOfPresentations: Int
    var audioScript: String
    var audioUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case options
        case correctOption
        case selectedOption
        case isAnswered
        case isAnsweredCorrectly
        case numberOfPresentations
        case audioScript
        case audioUrl
    }
}
