//
//  QuestionModel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/4/24.
//

import Foundation

struct Question: QuestionType, Equatable, Hashable {
    var refId: String  // Required
    var content: String  // Required
    var mcOptions: [String: Bool]  // Required
    var selectedOption: String?  // Optional
    var correction: String  // Required
    var numberOfPresentations: Int = 0  // Default value
    var questionScript: String  // Required
    var repeatQuestionScript: String  // Required
    var questionScriptAudioURL: String?  // Optional
    var correctionAudioURL: String?  // Optional
    var repeatQuestionAudioURL: String?  // Optional
    var coreTopic: String  // Required
    var quizId: String  // Required
    var userId: String  // Required
    var questionStatus: QuestionStatus?  // Required, cannot be nil

    enum CodingKeys: String, CodingKey {
        case refId
        case content
        case mcOptions
        case selectedOption
        case correction
        case numberOfPresentations
        case questionScript
        case repeatQuestionScript
        case questionScriptAudioURL
        case correctionAudioURL
        case repeatQuestionAudioURL
        case coreTopic
        case quizId
        case userId
        case questionStatus
    }

    // MARK: - Identifiable Conformance
    var id: String {
        return refId
    }

    // MARK: - Initializers
    init(
        refId: String,
        content: String,
        mcOptions: [String: Bool],
        selectedOption: String? = nil, // Default to nil
        correction: String,
        numberOfPresentations: Int = 0, // Default to 0
        questionScript: String,
        repeatQuestionScript: String,
        questionScriptAudioURL: String? = nil, // Default to nil
        correctionAudioURL: String? = nil, // Default to nil
        repeatQuestionAudioURL: String? = nil, // Default to nil
        coreTopic: String,
        quizId: String,
        userId: String,
        questionStatus: QuestionStatus // Required
    ) {
        self.refId = refId
        self.content = content
        self.mcOptions = mcOptions
        self.selectedOption = selectedOption
        self.correction = correction
        self.numberOfPresentations = numberOfPresentations
        self.questionScript = questionScript
        self.repeatQuestionScript = repeatQuestionScript
        self.questionScriptAudioURL = questionScriptAudioURL
        self.correctionAudioURL = correctionAudioURL
        self.repeatQuestionAudioURL = repeatQuestionAudioURL
        self.coreTopic = coreTopic
        self.quizId = quizId
        self.userId = userId
        self.questionStatus = questionStatus
    }

    // MARK: - Codable Conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        refId = try container.decode(String.self, forKey: .refId)
        content = try container.decode(String.self, forKey: .content)
        mcOptions = try container.decode([String: Bool].self, forKey: .mcOptions)
        selectedOption = try container.decodeIfPresent(String.self, forKey: .selectedOption)
        correction = try container.decode(String.self, forKey: .correction)
        numberOfPresentations = try container.decodeIfPresent(Int.self, forKey: .numberOfPresentations) ?? 0
        questionScript = try container.decode(String.self, forKey: .questionScript)
        repeatQuestionScript = try container.decode(String.self, forKey: .repeatQuestionScript)
        questionScriptAudioURL = try container.decodeIfPresent(String.self, forKey: .questionScriptAudioURL)
        correctionAudioURL = try container.decodeIfPresent(String.self, forKey: .correctionAudioURL)
        repeatQuestionAudioURL = try container.decodeIfPresent(String.self, forKey: .repeatQuestionAudioURL)
        coreTopic = try container.decode(String.self, forKey: .coreTopic)
        quizId = try container.decode(String.self, forKey: .quizId)
        userId = try container.decode(String.self, forKey: .userId)
        questionStatus = try container.decode(QuestionStatus.self, forKey: .questionStatus)
    }

    // MARK: - Encoding to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(refId, forKey: .refId)
        try container.encode(content, forKey: .content)
        try container.encode(mcOptions, forKey: .mcOptions)
        try container.encodeIfPresent(selectedOption, forKey: .selectedOption)
        try container.encode(correction, forKey: .correction)
        try container.encode(numberOfPresentations, forKey: .numberOfPresentations)
        try container.encode(questionScript, forKey: .questionScript)
        try container.encode(repeatQuestionScript, forKey: .repeatQuestionScript)
        try container.encodeIfPresent(questionScriptAudioURL, forKey: .questionScriptAudioURL)
        try container.encodeIfPresent(correctionAudioURL, forKey: .correctionAudioURL)
        try container.encodeIfPresent(repeatQuestionAudioURL, forKey: .repeatQuestionAudioURL)
        try container.encode(coreTopic, forKey: .coreTopic)
        try container.encode(quizId, forKey: .quizId)
        try container.encode(userId, forKey: .userId)
        try container.encode(questionStatus, forKey: .questionStatus)
    }

    // MARK: - Equatable and Hashable Conformance
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.refId == rhs.refId &&
               lhs.content == rhs.content &&
               lhs.mcOptions == rhs.mcOptions &&
               lhs.selectedOption == rhs.selectedOption &&
               lhs.correction == rhs.correction &&
               lhs.numberOfPresentations == rhs.numberOfPresentations &&
               lhs.questionScript == rhs.questionScript &&
               lhs.repeatQuestionScript == rhs.repeatQuestionScript &&
               lhs.questionScriptAudioURL == rhs.questionScriptAudioURL &&
               lhs.correctionAudioURL == rhs.correctionAudioURL &&
               lhs.repeatQuestionAudioURL == rhs.repeatQuestionAudioURL &&
               lhs.coreTopic == rhs.coreTopic &&
               lhs.quizId == rhs.quizId &&
               lhs.userId == rhs.userId &&
               lhs.questionStatus == rhs.questionStatus
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(refId)
        hasher.combine(content)
        hasher.combine(mcOptions)
        hasher.combine(selectedOption)
        hasher.combine(correction)
        hasher.combine(numberOfPresentations)
        hasher.combine(questionScript)
        hasher.combine(repeatQuestionScript)
        hasher.combine(questionScriptAudioURL)
        hasher.combine(correctionAudioURL)
        hasher.combine(repeatQuestionAudioURL)
        hasher.combine(coreTopic)
        hasher.combine(quizId)
        hasher.combine(userId)
        hasher.combine(questionStatus)
    }
}

struct QuestionStatus: Codable, Hashable, Equatable {
    var isAnswered: Bool?
    var isAnsweredCorrectly: Bool?
    var knowledgeConfirmed: Bool?

    enum CodingKeys: String, CodingKey {
        case isAnswered
        case isAnsweredCorrectly
        case knowledgeConfirmed
    }

    // Initializer with all properties
    init(isAnswered: Bool?, isAnsweredCorrectly: Bool?, knowledgeConfirmed: Bool?) {
        self.isAnswered = isAnswered
        self.isAnsweredCorrectly = isAnsweredCorrectly
        self.knowledgeConfirmed = knowledgeConfirmed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAnswered = try container.decodeIfPresent(Bool.self, forKey: .isAnswered)
        isAnsweredCorrectly = try container.decodeIfPresent(Bool.self, forKey: .isAnsweredCorrectly)
        knowledgeConfirmed = try container.decodeIfPresent(Bool.self, forKey: .knowledgeConfirmed)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isAnswered, forKey: .isAnswered)
        try container.encodeIfPresent(isAnsweredCorrectly, forKey: .isAnsweredCorrectly)
        try container.encodeIfPresent(knowledgeConfirmed, forKey: .knowledgeConfirmed)
    }

    // MARK: - Equatable and Hashable Conformance
    static func == (lhs: QuestionStatus, rhs: QuestionStatus) -> Bool {
        return lhs.isAnswered == rhs.isAnswered &&
               lhs.isAnsweredCorrectly == rhs.isAnsweredCorrectly &&
               lhs.knowledgeConfirmed == rhs.knowledgeConfirmed
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(isAnswered)
        hasher.combine(isAnsweredCorrectly)
        hasher.combine(knowledgeConfirmed)
    }
}


extension Question {
    mutating func selectAnswer(_ selectedOption: String) {
        // Set the selected option and mark the question as answered
        self.selectedOption = selectedOption
        questionStatus?.isAnswered = true // Assuming questionStatus has an isAnswered property
        
        // Check if the selected option is correct based on mcOptions
        if let isCorrect = mcOptions[selectedOption] {
            questionStatus?.isAnsweredCorrectly = isCorrect // Assuming questionStatus has isAnsweredCorrectly property
        } else {
            questionStatus?.isAnsweredCorrectly = false // Option not found, mark as incorrect
        }
    }
}


extension Question {
    static func fromMockData() -> [Question]? {
        // Mock JSON data as a string (representing an array of questions)
        let jsonString = """
        [
            {
                "refId": "d4003d1c-c8a4-4afa-99ec-f2f6fdd60490",
                "content": "Which muscle is primarily responsible for the movement of external rotation of the shoulder?",
                "mcOptions": {
                    "A (Infraspinatus)": true,
                    "B (Subscapularis)": false,
                    "C (Teres Major)": false,
                    "D (Supraspinatus)": false
                },
                "selectedOption": "",
                "correction": "The Infraspinatus is the adept muscle guiding the shoulder in external rotation, crucial for the stability of the shoulder joint.",
                "numberOfPresentations": 0,
                "questionScript": "In the complex ballet of our musculature, which muscle takes the lead role in orchestrating the external rotation of the shoulder?",
                "repeatQuestionScript": "Let us consider once more: Which muscle is responsible for the external rotation of the shoulder?",
                "questionScriptAudioURL": null,
                "correctionAudioURL": null,
                "repeatQuestionAudioURL": null,
                "coreTopic": "Muscular System",
                "quizId": "Human Anatomy",
                "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
                "questionStatus": {
                    "isAnswered": false,
                    "isAnsweredCorrectly": false,
                    "knowledgeConfirmed": false
                }
            },
            {
                "refId": "d628bfc2-8bad-41a3-b0b4-5f7319fc9a8c",
                "content": "Which part of the brain is responsible for regulating heart rate and respiration?",
                "mcOptions": {
                    "A (Cerebrum)": false,
                    "B (Medulla Oblongata)": true,
                    "C (Hypothalamus)": false,
                    "D (Cerebellum)": false
                },
                "selectedOption": "",
                "correction": "The Medulla Oblongata is tasked with the critical functions of regulating heart rate and respiration, a key area of the brainstem ensuring essential involuntary biological processes.",
                "numberOfPresentations": 0,
                "questionScript": "In the vast network of neural pathways, which part of the brain commands the involuntary rhythms of heart and breath?",
                "repeatQuestionScript": "Return to this inquiry: Which brain region is responsible for controlling heart rate and respiration?",
                "questionScriptAudioURL": null,
                "correctionAudioURL": null,
                "repeatQuestionAudioURL": null,
                "coreTopic": "Nervous System",
                "quizId": "Human Anatomy",
                "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
                "questionStatus": {
                    "isAnswered": false,
                    "isAnsweredCorrectly": false,
                    "knowledgeConfirmed": false
                }
            }
        ]
        """
        
        // Convert the JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        // Decode the JSON into an array of Question objects
        let decoder = JSONDecoder()
        do {
            let questions = try decoder.decode([Question].self, from: jsonData)
            return questions
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}


extension Question {
    static func mockAPI2() -> String {
        return "[\"[{\\\"quizId\\\":\\\"Human Anatomy\\\",\\\"userId\\\":\\\"4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58\\\",\\\"refId\\\":\\\"d4003d1c-c8a4-4afa-99ec-f2f6fdd60490\\\",\\\"content\\\":\\\"Which muscle is primarily responsible for the movement of external rotation of the shoulder?\\\",\\\"mcOptions\\\":{\\\"A (Infraspinatus)\\\":true,\\\"B (Deltoid)\\\":false,\\\"C (Teres Minor)\\\":false,\\\"D (Pectoralis Major)\\\":false},\\\"selectedOption\\\":\\\"\\\",\\\"correction\\\":\\\"Let us correct this misconception. The infraspinatus muscle, a vital component of the rotator cuff, expertly controls the shoulder's external rotation.\\\",\\\"numberOfPresentations\\\":0,\\\"questionScript\\\":\\\"Within the realm of shoulder movements, can you discern which muscle is chiefly responsible for external rotation?\\\",\\\"repeatQuestionScript\\\":\\\"Consider again: Which muscle primarily directs the shoulder's external rotation?\\\",\\\"questionScriptAudioUrl\\\":\\\"\\\",\\\"correctionAudioUrl\\\":\\\"\\\",\\\"repeatQuestionAudioUrl\\\":\\\"\\\",\\\"coreTopic\\\":\\\"Muscular System\\\",\\\"questionStatus\\\":{\\\"knowledgeConfirmed\\\":false,\\\"isAnsweredCorrectly\\\":false,\\\"isAnswered\\\":false}}]\""
    }
    
    static func mockAPI3() -> String {
        return """
        [{
            "quizId": "Human Anatomy",
            "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
            "refId": "d4003d1c-c8a4-4afa-99ec-f2f6fdd60490",
            "content": "Which muscle is primarily responsible for the movement of external rotation of the shoulder?",
            "mcOptions": {
                "A (Infraspinatus)": true,
                "B (Deltoid)": false,
                "C (Teres Minor)": false,
                "D (Pectoralis Major)": false
            },
            "selectedOption": "",
            "correction": "Let us correct this misconception. The infraspinatus muscle, a vital component of the rotator cuff, expertly controls the shoulder's external rotation.",
            "numberOfPresentations": 0,
            "questionScript": "Within the realm of shoulder movements, can you discern which muscle is chiefly responsible for external rotation?",
            "repeatQuestionScript": "Consider again: Which muscle primarily directs the shoulder's external rotation?",
            "questionScriptAudioUrl": "",
            "correctionAudioUrl": "",
            "repeatQuestionAudioUrl": "",
            "coreTopic": "Muscular System",
            "questionStatus": {
                "knowledgeConfirmed": false,
                "isAnsweredCorrectly": false,
                "isAnswered": false
            }
        }]
        """
    }
}

extension Question {
    static func decodeMockAPI3() -> [Question]? {
        let jsonString = mockAPI3()
        
        // Convert the JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        // Decode the JSON into an array of Question objects
        let decoder = JSONDecoder()
        do {
            let questions = try decoder.decode([Question].self, from: jsonData)
            return questions
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

