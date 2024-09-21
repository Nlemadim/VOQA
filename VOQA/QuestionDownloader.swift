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
    //var config: UserConfig
    var config: FakeConfig
    
    // Initialize QuestionDownloader with a UserConfig
    init(config: FakeConfig) {
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
