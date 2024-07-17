//
//  QuizConfigManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//

import Foundation

class QuizConfigManager {
    let networkService = NetworkService()
    var config: QuizSessionConfig?

    func loadLocalConfiguration() throws -> QuizSessionConfig {
        guard let path = Bundle.main.path(forResource: "SessionConfig", ofType: "json") else {
            print("Mock file not found in bundle.")
            throw NSError(domain: "QuizConfigManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Local configuration file not found"])
        }
        
        do {
            print("Found mock data file at path: \(path)")
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            print("Successfully loaded mock data. Attempting to decode...")
            
            let config = try JSONDecoder().decode(QuizSessionConfig.self, from: data)
            
            return config
        } catch {
            print("Error loading or decoding mock data: \(error)")
            throw error
        }
    }
    
    func downloadConfiguration() async throws -> QuizSessionConfig {
        let url = URL(string: ConfigurationUrls.sessionConfiguration)!
        let (data, _) = try await URLSession.shared.data(from: url)
        var config = try JSONDecoder().decode(QuizSessionConfig.self, from: data)
        
        config.controlFeedback = try await populateControlFeedback(config.controlFeedback)
        config.quizFeedback = try await populateQuizFeedback(config.quizFeedback)
        
        return config
    }

    private func populateControlFeedback(_ controlFeedback: ControlsFeedback) async throws -> ControlsFeedback {
        return ControlsFeedback(
            startQuiz: try await populateAudioUrls(for: controlFeedback.startQuiz),
            quit: try await populateAudioUrls(for: controlFeedback.quit),
            nextQuestion: try await populateAudioUrls(for: controlFeedback.nextQuestion),
            repeatQuestion: try await populateAudioUrls(for: controlFeedback.repeatQuestion)
        )
    }

    private func populateQuizFeedback(_ quizFeedback: QuizFeedback) async throws -> QuizFeedback {
        return QuizFeedback(
            incorrectAnswer: try await populateAudioUrls(for: quizFeedback.incorrectAnswer),
            correctAnswer: try await populateAudioUrls(for: quizFeedback.correctAnswer),
            noResponse: try await populateAudioUrls(for: quizFeedback.noResponse)
        )
    }
    
    func populateAudioUrls(for feedback: VoicedFeedback) async throws -> VoicedFeedback {
        // Populate audio URLs
        let populatedAudioUrls = try await self.populateFeedbackSfx(feedback.audioUrls)

        // Create a new VoicedFeedback instance with the populated audio URLs
        let populatedFeedback = VoicedFeedback(title: feedback.title, audioUrls: populatedAudioUrls)
        print("Populated feedback: \(populatedFeedback)")

        return populatedFeedback
    }
    
    private func populateFeedbackSfx(_ feedbackSfx: [FeedbackSfx]) async throws -> [FeedbackSfx] {
        return try await withThrowingTaskGroup(of: FeedbackSfx.self) { group in
            var results: [FeedbackSfx] = []
            
            for sfx in feedbackSfx {
                group.addTask {
                    print("Fetching URL for feedback message: \(sfx.urlScript)")
                    var updatedSfx = sfx
                    updatedSfx.audioUrl = try await self.networkService.fetchAudioUrl(for: updatedSfx.urlScript)
                    print("Fetched URL for message '\(sfx.urlScript)': \(updatedSfx.audioUrl)")
                    return updatedSfx
                }
            }
            
            for try await result in group {
                results.append(result)
            }
            
            return results
        }
    }
    
    func printUrls(for controlFeedback: ControlsFeedback) {
        print("Control Feedback URLs:")
        printUrls(from: controlFeedback.startQuiz.audioUrls, title: "Start Quiz")
        printUrls(from: controlFeedback.quit.audioUrls, title: "Quit")
        printUrls(from: controlFeedback.nextQuestion.audioUrls, title: "Next Question")
        printUrls(from: controlFeedback.repeatQuestion.audioUrls, title: "Repeat Question")
    }
    
    func printUrls(for quizFeedback: QuizFeedback) {
        print("Quiz Feedback URLs:")
        printUrls(from: quizFeedback.incorrectAnswer.audioUrls, title: "Incorrect Answer")
        printUrls(from: quizFeedback.correctAnswer.audioUrls, title: "Correct Answer")
        printUrls(from: quizFeedback.noResponse.audioUrls, title: "No Response")
    }
    
    private func printUrls(from audioUrls: [FeedbackSfx], title: String) {
        print("\(title):")
        for sfx in audioUrls {
            print("  - \(sfx.urlScript): \(sfx.audioUrl)")
        }
    }
    
    // Add a method to download questions
    func downloadQuestions() async throws -> [Question] {
        let url = URL(string: ConfigurationUrls.questionsRequestUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let questions = try JSONDecoder().decode([Question].self, from: data)
        return questions
    }
}

