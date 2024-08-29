//
//  VoiceConfigurationManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/28/24.
//

import Foundation

//TODO: Define Voice Config Error Loading/Access
class VoiceConfigurationManager {
    let networkService = NetworkService()
    
    // Method to populate all fields of QuizSessionConfig
    func populateQuizSessionConfig(_ config: QuizSessionConfig) async throws -> QuizSessionConfig {
        var updatedConfig = config
        
        // Populate control feedback
        updatedConfig.controlFeedback = try await populateControlFeedback(config.controlFeedback)
        
        // Populate quiz feedback
        updatedConfig.quizFeedback = try await populateQuizFeedback(config.quizFeedback)
        
        // Populate host messages if available
        if let hostMessages = config.quizHostMessages {
            updatedConfig.quizHostMessages = try await populateHostMessages(hostMessages)
        }
        
        return updatedConfig
    }
    
    // Method to load or download voice configuration based on the selected AddOnItem
    func loadVoiceConfiguration(for voice: AddOnItem) async throws -> QuizSessionConfig? {
        guard !(voice.isPaid ?? false) || hasAccessToVoice(voice) else {
            print("User does not have access to this paid voice: \(voice.name)")
            return nil
        }
        
        if let path = voice.path, let localConfig = try? loadLocalVoiceConfiguration(forPath: path) {
            return localConfig
        }
        
        return try await downloadVoiceConfig(for: voice)
    }
    
    // Load local voice configuration using the path property
    private func loadLocalVoiceConfiguration(forPath path: String) throws -> QuizSessionConfig? {
        guard let filePath = Bundle.main.path(forResource: path, ofType: "json") else {
            print("Local configuration file not found for path: \(path)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            let config = try JSONDecoder().decode(QuizSessionConfig.self, from: data)
            return config
        } catch {
            print("Error loading or decoding local data for path \(path): \(error)")
            throw error
        }
    }
    
    // Download voice configuration from a remote URL
    private func downloadVoiceConfig(for voice: AddOnItem) async throws -> QuizSessionConfig? {
        guard let audioURL = voice.audioURL else {
            print("No audio URL found for voice: \(voice.name)")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: audioURL)
        var config = try JSONDecoder().decode(QuizSessionConfig.self, from: data)
        
        config.controlFeedback = try await populateControlFeedback(config.controlFeedback)
        config.quizFeedback = try await populateQuizFeedback(config.quizFeedback)
        if let hostMessages = config.quizHostMessages {
            config.quizHostMessages = try await populateHostMessages(hostMessages)
        }
        
        return config
    }
    
    // Check if the user has access to a paid voice
    private func hasAccessToVoice(_ voice: AddOnItem) -> Bool {
        return !(voice.isPaid ?? false)
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
            noResponse: try await populateAudioUrls(for: quizFeedback.noResponse),
            giveScore: try await populateAudioUrls(for: quizFeedback.giveScore)
        )
    }
    
    private func populateHostMessages(_ hostMessages: QuizSessionHostMessages) async throws -> QuizSessionHostMessages {
        return QuizSessionHostMessages(
            hostNarratorIntro: try await populateAudioUrls(for: hostMessages.hostNarratorIntro),
            quizSessionIntro: try await populateAudioUrls(for: hostMessages.quizSessionIntro),
            messageFromSponsor: try await populateAudioUrls(for: hostMessages.messageFromSponsor),
            resumeFromSponsoredMessage: try await populateAudioUrls(for: hostMessages.resumeFromSponsoredMessage),
            prepareForReview: try await populateAudioUrls(for: hostMessages.prepareForReview),
            resumeFromReview: try await populateAudioUrls(for: hostMessages.resumeFromReview),
            sponsoredOutroMessage: try await populateAudioUrls(for: hostMessages.sponsoredOutroMessage),
            outro: try await populateAudioUrls(for: hostMessages.outro)
        )
    }
    
    
    func populateAudioUrls(for feedback: VoicedFeedback) async throws -> VoicedFeedback {
        let populatedAudioUrls = try await self.populateFeedbackSfx(feedback.audioUrls)
        return VoicedFeedback(title: feedback.title, audioUrls: populatedAudioUrls)
    }
    
    private func populateFeedbackSfx(_ feedbackSfx: [FeedbackSfx]) async throws -> [FeedbackSfx] {
        return try await withThrowingTaskGroup(of: FeedbackSfx.self) { group in
            var results: [FeedbackSfx] = []
            
            for sfx in feedbackSfx {
                group.addTask {
                    var updatedSfx = sfx
                    updatedSfx.audioUrl = try await self.networkService.fetchAudioUrl(for: updatedSfx.urlScript)
                    return updatedSfx
                }
            }
            
            for try await result in group {
                results.append(result)
            }
            
            return results
        }
    }
}


extension VoiceConfigurationManager {
    // Method to print the entire QuizSessionConfig
    func printQuizSessionConfig(_ config: QuizSessionConfig) {
        print("Quiz Session Configuration:")
        printControlFeedback(config.controlFeedback)
        printQuizFeedback(config.quizFeedback)
        
        if let hostMessages = config.quizHostMessages {
            printHostMessages(hostMessages)
        }
    }

    // Method to print control feedback
    private func printControlFeedback(_ controlFeedback: ControlsFeedback) {
        print("Control Feedback:")
        printVoicedFeedback(controlFeedback.startQuiz, title: "Start Quiz")
        printVoicedFeedback(controlFeedback.quit, title: "Quit")
        printVoicedFeedback(controlFeedback.nextQuestion, title: "Next Question")
        printVoicedFeedback(controlFeedback.repeatQuestion, title: "Repeat Question")
    }

    // Method to print quiz feedback
    private func printQuizFeedback(_ quizFeedback: QuizFeedback) {
        print("Quiz Feedback:")
        printVoicedFeedback(quizFeedback.incorrectAnswer, title: "Incorrect Answer")
        printVoicedFeedback(quizFeedback.correctAnswer, title: "Correct Answer")
        printVoicedFeedback(quizFeedback.noResponse, title: "No Response")
        printVoicedFeedback(quizFeedback.giveScore, title: "Give Score")
    }

    // Method to print host messages
    private func printHostMessages(_ hostMessages: QuizSessionHostMessages) {
        print("Host Messages:")
        printVoicedFeedback(hostMessages.hostNarratorIntro, title: "Host Narrator Intro")
        printVoicedFeedback(hostMessages.quizSessionIntro, title: "Quiz Session Intro")
        printVoicedFeedback(hostMessages.messageFromSponsor, title: "Message From Sponsor")
        printVoicedFeedback(hostMessages.resumeFromSponsoredMessage, title: "Resume From Sponsored Message")
        printVoicedFeedback(hostMessages.prepareForReview, title: "Prepare For Review")
        printVoicedFeedback(hostMessages.resumeFromReview, title: "Resume From Review")
        printVoicedFeedback(hostMessages.sponsoredOutroMessage, title: "Sponsored Outro Message")
        printVoicedFeedback(hostMessages.outro, title: "Outro")
    }

    // Helper method to print VoicedFeedback details
    private func printVoicedFeedback(_ feedback: VoicedFeedback, title: String) {
        print("\(title):")
        for sfx in feedback.audioUrls {
            print("  - Title: \(sfx.title)")
            print("  - URL Script: \(sfx.urlScript)")
            print("  - Audio URL: \(sfx.audioUrl)")
        }
    }
}
