//
//  NetworkService.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//

import Foundation

class NetworkService {
    
    func fetchAudioUrl(for feedbackMessage: String) async throws -> String {
        let cleanedMessage = cleanMessage(feedbackMessage)
        let encodedMessage = cleanedMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(ConfigurationUrls.voiceFeedbackRequestUrl)?feedbackMessage=\(encodedMessage)"
        
        print("Fetching audio URL for message: \(feedbackMessage)")
        print("Encoded message: \(encodedMessage)")
        print("Request URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        } else {
            print("No valid HTTP response received")
        }

        let audioUrl = String(data: data, encoding: .utf8) ?? ""
        
        print("Downloaded audio URL: \(audioUrl)")
        
        return audioUrl
    }
    
    func downloadData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        print("Starting download from URL: \(urlString)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        }
        
        print("Download complete, data size: \(data.count) bytes")
        return data
    }
    
    func fetchQuestions() async throws -> [Question] {
        print("Fetching questions from URL: \(ConfigurationUrls.questionsRequestUrl)")
        let data = try await downloadData(from: ConfigurationUrls.questionsRequestUrl)
        
        print("Decoding questions...")
        let questions = try JSONDecoder().decode([Question].self, from: data)
        
        print("Successfully decoded \(questions.count) questions.")
        
        var processedQuestions = questions
        var failedQuestions: [Int] = []
        
        // Format questions and download audio URLs concurrently
        try await withThrowingTaskGroup(of: (Int, Question?).self) { group in
            for i in 0..<questions.count {
                let question = questions[i]
                group.addTask {
                    var newQuestion = question
                    newQuestion.audioScript = QuestionFormatter.formatQuestion(question: question)
                    
                    do {
                        let audioUrl = try await self.fetchAudioUrl(for: newQuestion.audioScript)
                        let overviewUrl = try await self.fetchAudioUrl(for: newQuestion.overview)
                        
                        newQuestion.audioUrl = audioUrl
                        newQuestion.overviewUrl = overviewUrl
                        return (i, newQuestion)
                    } catch {
                        print("Error fetching audio URLs for question at index \(i): \(error)")
                        return (i, nil)
                    }
                }
            }
            
            for try await result in group {
                if let question = result.1 {
                    processedQuestions[result.0] = question
                } else {
                    failedQuestions.append(result.0)
                }
            }
        }
        
        if !failedQuestions.isEmpty {
            print("Retrying failed questions...")
            await retryFailedQuestions(questions: &processedQuestions, failedIndices: failedQuestions)
        }
        
        // Print URLs for debugging
        for question in processedQuestions {
            print("Question ID: \(question.id)")
            print("Audio URL: \(question.audioUrl)")
            print("Overview URL: \(question.overviewUrl)")
        }
        
        return processedQuestions
    }
    
//    func fetchQuestionsV2(requestBody: QuestionRequestBody) async throws -> [QuestionV2] {
//        print("Fetching questions V2 from URL: \(ConfigurationUrls.questionsRequestUrl)")
//        
//        // Prepare the URL and request
//        guard let url = URL(string: ConfigurationUrls.questionsRequestUrl) else {
//            throw URLError(.badURL)
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // Encode the request body
//        let bodyData = try JSONEncoder().encode(requestBody)
//        request.httpBody = bodyData
//        
//        // Download data
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        if let httpResponse = response as? HTTPURLResponse {
//            print("HTTP Response Status Code: \(httpResponse.statusCode)")
//        }
//        
//        print("Decoding questions V2...")
//        
//        // Decode the data into the new QuestionV2 model
//        let questions = try JSONDecoder().decode([QuestionV2].self, from: data)
//        
//        print("Successfully decoded \(questions.count) questions V2.")
//        
//        return questions
//    }

    private func retryFailedQuestions(questions: inout [Question], failedIndices: [Int]) async {
        for index in failedIndices {
            var question = questions[index]
            question.audioScript = QuestionFormatter.formatQuestion(question: question)
            
            do {
                let audioUrl = try await self.fetchAudioUrl(for: question.audioScript)
                let overviewUrl = try await self.fetchAudioUrl(for: question.overview)
                
                question.audioUrl = audioUrl
                question.overviewUrl = overviewUrl
                questions[index] = question
            } catch {
                print("Retry failed: Error fetching audio URLs for question at index \(index): \(error)")
            }
        }
    }
    
    private func cleanMessage(_ message: String) -> String {
        var cleanedMessage = message.replacingOccurrences(of: "\n", with: " ")
        cleanedMessage = cleanedMessage.replacingOccurrences(of: "\r", with: " ")
        cleanedMessage = cleanedMessage.replacingOccurrences(of: "\"", with: "'")
        cleanedMessage = cleanedMessage.replacingOccurrences(of: "!", with: "")
        return cleanedMessage
    }
}


extension NetworkService {
    
    // Method to post user profile to the backend
    func postUserProfile(_ profile: UserProfile) async throws {
        guard let url = URL(string: ConfigurationUrls.createUserProfile) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(profile)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Network Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user profile"])
        }
    }
}



extension NetworkService {
    
    // MARK: - Fetch Questions V2 with request body
    func fetchQuestionsV2(requestBody: QuestionRequestBody) async throws -> [QuestionV2] {
        print("Fetching questions V2 from URL: \(ConfigurationUrls.downloadVoqalizedQuestions)")
        
        // Prepare the URL and request
        guard let url = URL(string: ConfigurationUrls.downloadVoqalizedQuestions) else {
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
            
            print("Attempting to decode response data into QuestionV2 models...")
            
            let questions = try JSONDecoder().decode([QuestionV2].self, from: data)
            
            print("Successfully decoded \(questions.count) questions V2.")
            
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




