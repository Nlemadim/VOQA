//
//  QuestionDownloader.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/10/24.
//

import SwiftUI
import AVKit

struct FakeConfig {
    let userId: String
    let quizTitle: String
    let narrator: String
    let language: String
    
    init(userId: String, quizTitle: String, narrator: String, language: String) {
        self.userId = userId
        self.quizTitle = quizTitle
        self.narrator = narrator
        self.language = language
    }
}

class QuestionDownloader {
    let networkService = NetworkService()
    var config: UserConfig
   // var config: FakeConfig
    
    // Initialize QuestionDownloader with a UserConfig
    init(config: UserConfig) {
        self.config = config
    }
    
    // MARK: - Expose a public method to download quiz questions
    func downloadQuizQuestions(quizTitle: String, questionTypeRequest: String, maxNumberOfQuestions: Int?) async throws -> [Question] {
        let requestBody = QuestionRequestBody(
            userId: "rBkUyTtc2XXXcj43u53N",
            quizTitle: quizTitle,
            request: questionTypeRequest,
            narrator: narratorVoiceSelection(narrator: "Gus"),
            numberOfQuestions: maxNumberOfQuestions ?? 5
        )
        let questions = try await fetchQuestions(requestBody: requestBody)
        return questions
    }

    // MARK: - Private: Fetch Questions and manage audio download
    private func fetchQuestions(requestBody: QuestionRequestBody) async throws -> [Question] {
        print("Starting Download")
        let questions = try await networkService.fetchQuestionsV2(requestBody: requestBody)

        let processedQuestions = questions

        return processedQuestions
    }
    
    private func narratorVoiceSelection(narrator: String) -> String {
        // Convert the string narrator to a VoiceSelector case
        guard let selectedVoice = VoiceSelector(rawValue: narrator) else {
            // Default to Gus if the narrator is not recognized
            return VoiceSelector.gus.voiceDesignation
        }
        
        // Return the voice designation for the selected narrator
        return selectedVoice.voiceDesignation
    }
    
    func loadMockQuestions() -> [Question] {
        let question1 = Question(
            refId: "ca007f3b-424c-45e8-8305-0408d576da03",
            content: "In the context of cellular respiration, what role does the electron transport chain play?",
            mcOptions: [
                "A: Breaks down glucose into pyruvate": false,
                "C: Generates ATP by oxidative phosphorylation": true,
                "B: Synthesizes glucose through photosynthesis": false,
                "D: Facilitates the synthesis of protein": false
            ],
            correctOption: "B",
            selectedOption: nil,
            correction: "Your engagement with this question is appreciated, yet the precise answer is Option C: Generates ATP by oxidative phosphorylation. The electron transport chain is integral to cellular respiration, transferring electrons from NADH and FADH2 to oxygen, a process known as oxidative phosphorylation. This critical step generates a significant amount of ATP, the energy currency of the cell, supporting various cellular functions. This understanding underscores the importance of energy production mechanisms in biology.",
            isAnsweredOptional: nil,
            isAnsweredCorrectlyOptional: nil,
            numberOfPresentations: 2,
            questionScript: "Let's dive into the fascinating world of cellular respiration, a crucial process that cells use to break down glucose and produce the energy carrier, ATP. A key player in this process is the electron transport chain, known for its role in oxidative phosphorylation. *Here are your options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein. Reflect on each option and choose wisely.",
            repeatQuestionScript: "In the context of cellular respiration, what role does the electron transport chain play? *Here are the options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein.",
            questionScriptAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_questionScript.mp3",
            correctionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_correction.mp3",
            repeatQuestionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_repeatQuestionScript.mp3",
            coreTopic: "Biological and Biochemical Foundations",
            quizId: "MCAT",
            userId: "rBkUyTtc2XXXcj43u53N",
            questionStatus: QuestionStatus(isAnsweredCorrectly: false, isAnswered: false, knowledgeConfirmed: false)
        )
        
        let question2 = question1.copy(
            refId: "e533677c-dbc8-4ffd-9259-7f6ede2c01bc",
            content: "Which concept is central to understanding the flow of genetic information within a biological system?",
            mcOptions: [
                "C: Law of independent assortment": false,
                "B: Central dogma of molecular biology": true,
                "D: Law of segregation": false,
                "A: Theory of evolution by natural selection": false
            ],
            questionScriptAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/e533677c-dbc8-4ffd-9259-7f6ede2c01bc_questionScript.mp3",
            correctionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/e533677c-dbc8-4ffd-9259-7f6ede2c01bc_correction.mp3",
            repeatQuestionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/e533677c-dbc8-4ffd-9259-7f6ede2c01bc_repeatQuestionScript.mp3"
        )
        
        let question3 = question1.copy(
            refId: "a5723acc-3857-44db-91ba-cdf5b34e5915",
            content: "Which of the following enzymes is crucial for the unwinding of DNA during replication?",
            mcOptions: [
                "B: Ligase": false,
                "D: RNA polymerase": false,
                "A: Helicase": true,
                "C: DNA polymerase": false
            ],
            questionScriptAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_questionScript.mp3",
            correctionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_correction.mp3",
            repeatQuestionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_repeatQuestionScript.mp3"
        )
        
        return [question1, question2, question3]
    }
}


extension Question {
    
    func copy(refId: String, content: String, mcOptions: [String: Bool], questionScriptAudioUrl: String, correctionAudioUrl: String, repeatQuestionAudioUrl: String) -> Question {
        return Question(
            refId: refId,
            content: content,
            mcOptions: mcOptions,
            correctOption: self.correctOption,
            selectedOption: self.selectedOption,
            correction: self.correction,
            isAnsweredOptional: self.isAnsweredOptional,
            isAnsweredCorrectlyOptional: self.isAnsweredCorrectlyOptional,
            numberOfPresentations: self.numberOfPresentations,
            questionScript: self.questionScript,
            repeatQuestionScript: self.repeatQuestionScript,
            questionScriptAudioUrl: questionScriptAudioUrl,
            correctionAudioUrl: correctionAudioUrl,
            repeatQuestionAudioUrl: repeatQuestionAudioUrl,
            coreTopic: self.coreTopic,
            quizId: self.quizId,
            userId: self.userId,
            questionStatus: self.questionStatus
        )
    }
}

extension NetworkService {

    // MARK: - Fetch Questions V2 with request body
    func fetchQuestionsV2(requestBody: QuestionRequestBody) async throws -> [Question] {
        print("Fetching questions V2 from URL: \(ConfigurationUrls.testQuestionsDownload)")

        // Prepare the URL and request
        guard let url = URL(string: ConfigurationUrls.testQuestionsDownload) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode the request body
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            request.httpBody = bodyData
            print("Request body successfully encoded.")
            print("Request Body: \(String(data: bodyData, encoding: .utf8) ?? "Unable to encode body")")
        } catch {
            print("Failed to encode request body: \(error)")
            throw error
        }

        // Make the network call
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }

            print("Received raw data size: \(data.count) bytes")

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            } else {
                print("Unable to convert data to string for debugging")
            }

            if data.count == 0 {
                print("Received empty data from the server.")
                throw URLError(.zeroByteResource)
            }

            print("Attempting to decode response data into QuestionV2 models...")

            let questions = try JSONDecoder().decode([Question].self, from: data)

            print("Successfully decoded \(questions.count) questions V2.")
            print("Decoded questions: \(questions)")  // Print the decoded data

            return questions

        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError.localizedDescription)")
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted error: \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("Key not found: \(key.stringValue), \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type), \(context.debugDescription)")
            case .valueNotFound(let value, let context):
                print("Value not found: \(value), \(context.debugDescription)")
            default:
                print("Unknown decoding error.")
            }
            throw decodingError
        } catch {
            print("Network or other error: \(error.localizedDescription)")
            throw error
        }
    }
}



