//
//  QuizConfigManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//
import Foundation

class QuizConfigManager {
    let networkService = NetworkService()

    func downloadConfiguration() async throws -> QuizSessionConfig {
        let url = URL(string: ConfigurationUrls.sessionConfiguration)!
        let (data, _) = try await URLSession.shared.data(from: url)
        var config = try JSONDecoder().decode(QuizSessionConfig.self, from: data)

        // Fetch control feedback URLs
        config.controlFeedback.startQuiz = try await populateAudioUrls(for: config.controlFeedback.startQuiz)
        config.controlFeedback.quit = try await populateAudioUrls(for: config.controlFeedback.quit)
        config.controlFeedback.nextQuestion = try await populateAudioUrls(for: config.controlFeedback.nextQuestion)
        config.controlFeedback.repeatQuestioon = try await populateAudioUrls(for: config.controlFeedback.repeatQuestioon)

        // Fetch quiz feedback URLs
        config.quizFeedback.incorrectAnswer = try await populateAudioUrls(for: config.quizFeedback.incorrectAnswer)
        config.quizFeedback.correctAnswer = try await populateAudioUrls(for: config.quizFeedback.correctAnswer)
        config.quizFeedback.noResponse = try await populateAudioUrls(for: config.quizFeedback.noResponse)

        return config
    }

    func populateAudioUrls<T: VoicedFeedback>(for feedback: T) async throws -> T {
        var populatedFeedback = feedback
        populatedFeedback.audioUrls = try await self.populateFeedbackSfx(feedback.audioUrls)
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
        printUrls(from: controlFeedback.repeatQuestioon.audioUrls, title: "Repeat Question")
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
}

