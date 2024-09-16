//
//  QuestionV2.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

struct QuestionV2: Codable {
    var refId: String
    var content: String
    var options: [String: Bool]
    var correctOption: String?
    var selectedOption: String?
    var correction: String
    var isAnswered: Bool? // Optional to handle missing keys
    var isAnsweredCorrectly: Bool? // Optional to handle missing keys
    var numberOfPresentations: Int
    var questionScript: String
    var repeatQuestionScript: String // Added repeatQuestionScript
    var questionScriptAudioUrl: String? // Adjusted to match JSON field "questionScriptAudioURL"
    var correctionAudioUrl: String? // Adjusted to match JSON field "correctionAudioUrl"
    var repeatQuestionAudioUrl: String? // Adjusted to match JSON field "repeatQuestionAudioURL"
    var coreTopic: String
    var quizId: String
    var userId: String
    var status: Status?

    struct Status: Codable {
        var isAnsweredCorrectly: Bool?
        var isAnswered: Bool?
        var knowledgeConfirmed: Bool?
    }

    enum CodingKeys: String, CodingKey {
        case refId
        case content = "question"
        case options
        case correctOption
        case selectedOption
        case correction
        case isAnswered
        case isAnsweredCorrectly
        case numberOfPresentations
        case questionScript
        case repeatQuestionScript // Added to match "repeatQuestionScript" from JSON
        case questionScriptAudioUrl = "questionScriptAudioURL"
        case correctionAudioUrl = "correctionAudioUrl"
        case repeatQuestionAudioUrl = "repeatQuestionAudioURL"
        case coreTopic
        case quizId
        case userId
        case status
    }
}


//extension QuestionV2: DownloadableQuestion {
//    // Download the audio package using NetworkService
//    func downloadAudio(for userId: String, narrator: String, language: String) async throws -> QuestionAudioPackage {
//        let networkService = NetworkService()
//        return try await networkService.fetchQuestionAudioPack(for: self, userId: userId, narrator: narrator, language: language)
//    }
//    
//    // Assign the downloaded audio URLs to the corresponding properties
//    mutating func assignAudioUrls(from audioPackage: QuestionAudioPackage) {
//        self.questionScriptAudioUrl = audioPackage.questionScriptAudio
//        self.correctionAudioUrl = audioPackage.correctionAudio
//        self.repeatQuestionAudioUrl = audioPackage.repeatAudio
//    }
//}
