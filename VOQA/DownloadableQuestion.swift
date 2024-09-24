//
//  DownloadableQuestion.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

/// A struct representing the status of the question.
struct QuestionStatus: Codable, Hashable, Equatable {
    var isAnsweredCorrectly: Bool?
    var isAnswered: Bool?
    var knowledgeConfirmed: Bool?

    enum CodingKeys: String, CodingKey {
        case isAnsweredCorrectly
        case isAnswered
        case knowledgeConfirmed
    }

    init(isAnsweredCorrectly: Bool?, isAnswered: Bool?, knowledgeConfirmed: Bool?) {
        self.isAnsweredCorrectly = isAnsweredCorrectly
        self.isAnswered = isAnswered
        self.knowledgeConfirmed = knowledgeConfirmed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAnsweredCorrectly = try container.decodeIfPresent(Bool.self, forKey: .isAnsweredCorrectly)
        isAnswered = try container.decodeIfPresent(Bool.self, forKey: .isAnswered)
        knowledgeConfirmed = try container.decodeIfPresent(Bool.self, forKey: .knowledgeConfirmed)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isAnsweredCorrectly, forKey: .isAnsweredCorrectly)
        try container.encodeIfPresent(isAnswered, forKey: .isAnswered)
        try container.encodeIfPresent(knowledgeConfirmed, forKey: .knowledgeConfirmed)
    }

    // MARK: - Equatable Conformance

    static func == (lhs: QuestionStatus, rhs: QuestionStatus) -> Bool {
        return lhs.isAnsweredCorrectly == rhs.isAnsweredCorrectly &&
               lhs.isAnswered == rhs.isAnswered &&
               lhs.knowledgeConfirmed == rhs.knowledgeConfirmed
    }

    // MARK: - Hashable Conformance

    func hash(into hasher: inout Hasher) {
        hasher.combine(isAnsweredCorrectly)
        hasher.combine(isAnswered)
        hasher.combine(knowledgeConfirmed)
    }
}

/// A protocol that defines the essential properties required by QuestionPlayer to handle any question type.
protocol QuestionType: Codable, Identifiable where ID == String {
    /// A unique identifier for the question.
    var id: String { get }
    
    /// The main content or text of the question.
    var content: String { get }
    
    /// The URL string pointing to the audio script of the question.
    var audioURL: String? { get }
    
    /// A dictionary representing the options for the question.
    var mcOptions: [String: Bool] { get }
    
    /// The correct option's identifier or key.
    var correctOption: String? { get }
    
    /// The option selected by the user.
    var selectedOption: String? { get }
    
    /// The correction or explanation for the question.
    var correction: String { get }
    
    /// Indicates whether the question has been answered.
    var isAnswered: Bool { get }
    
    /// Indicates whether the question was answered correctly.
    var isAnsweredCorrectly: Bool { get }
    
    /// The number of times the question has been presented.
    var numberOfPresentations: Int { get }
    
    /// The script for the question's audio narration.
    var questionScript: String { get }
    
    /// The script for repeating the question's audio narration.
    var repeatQuestionScript: String { get }
    
    /// The URL string pointing to the question script audio.
    var questionScriptAudioURL: String? { get }
    
    /// The URL string pointing to the correction audio.
    var correctionAudioURL: String? { get }
    
    /// The URL string pointing to the repeat question audio.
    var repeatQuestionAudioURL: String? { get }
    
    /// The core topic of the question.
    var coreTopic: String { get }
    
    /// The identifier for the associated quiz.
    var quizId: String { get }
    
    /// The identifier for the user who answered the question.
    var userId: String { get }
    
    /// The status of the question.
    var questionStatus: QuestionStatus? { get }
}


/// The updated `Question` model conforming to `QuestionType` and `Equatable`.
struct Question: QuestionType, Equatable, Hashable {
    // MARK: - Properties
    
    var refId: String
    var content: String
    var mcOptions: [String: Bool]
    var correctOption: String?
    var selectedOption: String?
    var correction: String
    var isAnsweredOptional: Bool? // Optional to handle missing keys
    var isAnsweredCorrectlyOptional: Bool? // Optional to handle missing keys
    var numberOfPresentations: Int
    var questionScript: String
    var repeatQuestionScript: String
    var questionScriptAudioUrl: String?
    var correctionAudioUrl: String?
    var repeatQuestionAudioUrl: String?
    var coreTopic: String
    var quizId: String
    var userId: String
    var questionStatus: QuestionStatus?
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case refId
        case content = "question"
        case mcOptions = "options" // Renamed to match protocol
        case correctOption
        case selectedOption
        case correction
        case isAnsweredOptional = "isAnswered"
        case isAnsweredCorrectlyOptional = "isAnsweredCorrectly"
        case numberOfPresentations
        case questionScript
        case repeatQuestionScript
        case questionScriptAudioUrl = "questionScriptAudioURL"
        case correctionAudioUrl = "correctionAudioUrl"
        case repeatQuestionAudioUrl = "repeatQuestionAudioURL"
        case coreTopic
        case quizId
        case userId
        case questionStatus = "status"
    }
    
    // MARK: - Identifiable Conformance
    
    /// A unique identifier for the question.
    var id: String {
        return refId
    }
    
    // MARK: - QuestionType Protocol Conformance
    
    /// The URL string pointing to the audio script of the question.
    var audioURL: String? {
        return questionScriptAudioUrl
    }
    
    /// Indicates whether the question has been answered.
    var isAnswered: Bool {
        return isAnsweredOptional ?? false
    }
    
    /// Indicates whether the question was answered correctly.
    var isAnsweredCorrectly: Bool {
        return isAnsweredCorrectlyOptional ?? false
    }
    
    /// The URL string pointing to the question script audio.
    var questionScriptAudioURL: String? {
        return questionScriptAudioUrl
    }
    
    /// The URL string pointing to the correction audio.
    var correctionAudioURL: String? {
        return correctionAudioUrl
    }
    
    /// The URL string pointing to the repeat question audio.
    var repeatQuestionAudioURL: String? {
        return repeatQuestionAudioUrl
    }
    
    init(
        refId: String,
        content: String,
        mcOptions: [String: Bool],
        correctOption: String?,
        selectedOption: String?,
        correction: String,
        isAnsweredOptional: Bool?,
        isAnsweredCorrectlyOptional: Bool?,
        numberOfPresentations: Int,
        questionScript: String,
        repeatQuestionScript: String,
        questionScriptAudioUrl: String?,
        correctionAudioUrl: String?,
        repeatQuestionAudioUrl: String?,
        coreTopic: String,
        quizId: String,
        userId: String,
        questionStatus: QuestionStatus?
    ) {
        self.refId = refId
        self.content = content
        self.mcOptions = mcOptions
        self.correctOption = correctOption
        self.selectedOption = selectedOption
        self.correction = correction
        self.isAnsweredOptional = isAnsweredOptional
        self.isAnsweredCorrectlyOptional = isAnsweredCorrectlyOptional
        self.numberOfPresentations = numberOfPresentations
        self.questionScript = questionScript
        self.repeatQuestionScript = repeatQuestionScript
        self.questionScriptAudioUrl = questionScriptAudioUrl
        self.correctionAudioUrl = correctionAudioUrl
        self.repeatQuestionAudioUrl = repeatQuestionAudioUrl
        self.coreTopic = coreTopic
        self.quizId = quizId
        self.userId = userId
        self.questionStatus = questionStatus
    }
    
    // MARK: - Equatable Conformance
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.refId == rhs.refId &&
        lhs.content == rhs.content &&
        lhs.mcOptions == rhs.mcOptions &&
        lhs.correctOption == rhs.correctOption &&
        lhs.selectedOption == rhs.selectedOption &&
        lhs.correction == rhs.correction &&
        lhs.isAnsweredOptional == rhs.isAnsweredOptional &&
        lhs.isAnsweredCorrectlyOptional == rhs.isAnsweredCorrectlyOptional &&
        lhs.numberOfPresentations == rhs.numberOfPresentations &&
        lhs.questionScript == rhs.questionScript &&
        lhs.repeatQuestionScript == rhs.repeatQuestionScript &&
        lhs.questionScriptAudioUrl == rhs.questionScriptAudioUrl &&
        lhs.correctionAudioUrl == rhs.correctionAudioUrl &&
        lhs.repeatQuestionAudioUrl == rhs.repeatQuestionAudioUrl &&
        lhs.coreTopic == rhs.coreTopic &&
        lhs.quizId == rhs.quizId &&
        lhs.userId == rhs.userId &&
        lhs.questionStatus == rhs.questionStatus
    }
    
    
    // MARK: - Codable Conformance
    
    /// Custom initializer to decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        refId = try container.decode(String.self, forKey: .refId)
        content = try container.decode(String.self, forKey: .content)
        mcOptions = try container.decode([String: Bool].self, forKey: .mcOptions)
        correctOption = try container.decodeIfPresent(String.self, forKey: .correctOption)
        selectedOption = try container.decodeIfPresent(String.self, forKey: .selectedOption)
        correction = try container.decode(String.self, forKey: .correction)
        isAnsweredOptional = try container.decodeIfPresent(Bool.self, forKey: .isAnsweredOptional)
        isAnsweredCorrectlyOptional = try container.decodeIfPresent(Bool.self, forKey: .isAnsweredCorrectlyOptional)
        numberOfPresentations = try container.decode(Int.self, forKey: .numberOfPresentations)
        questionScript = try container.decode(String.self, forKey: .questionScript)
        repeatQuestionScript = try container.decode(String.self, forKey: .repeatQuestionScript)
        questionScriptAudioUrl = try container.decodeIfPresent(String.self, forKey: .questionScriptAudioUrl)
        correctionAudioUrl = try container.decodeIfPresent(String.self, forKey: .correctionAudioUrl)
        repeatQuestionAudioUrl = try container.decodeIfPresent(String.self, forKey: .repeatQuestionAudioUrl)
        coreTopic = try container.decode(String.self, forKey: .coreTopic)
        quizId = try container.decode(String.self, forKey: .quizId)
        userId = try container.decode(String.self, forKey: .userId)
        questionStatus = try container.decodeIfPresent(QuestionStatus.self, forKey: .questionStatus)
    }
    
    /// Custom encoder to encode to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(refId, forKey: .refId)
        try container.encode(content, forKey: .content)
        try container.encode(mcOptions, forKey: .mcOptions)
        try container.encodeIfPresent(correctOption, forKey: .correctOption)
        try container.encodeIfPresent(selectedOption, forKey: .selectedOption)
        try container.encode(correction, forKey: .correction)
        try container.encodeIfPresent(isAnsweredOptional, forKey: .isAnsweredOptional)
        try container.encodeIfPresent(isAnsweredCorrectlyOptional, forKey: .isAnsweredCorrectlyOptional)
        try container.encode(numberOfPresentations, forKey: .numberOfPresentations)
        try container.encode(questionScript, forKey: .questionScript)
        try container.encode(repeatQuestionScript, forKey: .repeatQuestionScript)
        try container.encodeIfPresent(questionScriptAudioUrl, forKey: .questionScriptAudioUrl)
        try container.encodeIfPresent(correctionAudioUrl, forKey: .correctionAudioUrl)
        try container.encodeIfPresent(repeatQuestionAudioUrl, forKey: .repeatQuestionAudioUrl)
        try container.encode(coreTopic, forKey: .coreTopic)
        try container.encode(quizId, forKey: .quizId)
        try container.encode(userId, forKey: .userId)
        try container.encodeIfPresent(questionStatus, forKey: .questionStatus)
    }
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(refId)
        hasher.combine(content)
        hasher.combine(mcOptions)
        hasher.combine(correctOption)
        hasher.combine(selectedOption)
        hasher.combine(correction)
        hasher.combine(isAnsweredOptional)
        hasher.combine(isAnsweredCorrectlyOptional)
        hasher.combine(numberOfPresentations)
        hasher.combine(questionScript)
        hasher.combine(repeatQuestionScript)
        hasher.combine(questionScriptAudioUrl)
        hasher.combine(correctionAudioUrl)
        hasher.combine(repeatQuestionAudioUrl)
        hasher.combine(coreTopic)
        hasher.combine(quizId)
        hasher.combine(userId)
        hasher.combine(questionStatus)
    }
}

extension Question {
    mutating func selectAnswer(_ selectedOption: String) {
        // Set the selected option
        self.selectedOption = selectedOption
        
        // Mark the question as answered
        self.isAnsweredOptional = true
        
        // Check if the selected option is correct based on mcOptions
        if let isCorrect = mcOptions[selectedOption] {
            self.isAnsweredCorrectlyOptional = isCorrect
        }
    }
}
