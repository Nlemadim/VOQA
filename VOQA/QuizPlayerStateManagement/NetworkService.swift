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

