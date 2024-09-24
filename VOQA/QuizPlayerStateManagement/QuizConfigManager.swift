//
//  QuizConfigManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//

import Foundation

class QuizConfigManager {
    let networkService = NetworkService()
    let voiceConfigurationManager = VoiceConfigurationManager()
    var config: QuizSessionConfig?
    
    func downloadConfiguration() async throws -> QuizSessionConfig {
        let url = URL(string: ConfigurationUrls.sessionConfiguration)!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the configuration from the downloaded data
        var config = try JSONDecoder().decode(QuizSessionConfig.self, from: data)
        
        // Use VoiceConfigurationManager to populate audio URLs for the config
        config = try await voiceConfigurationManager.populateQuizSessionConfig(config)
        
        // Assign the populated config to the class property
        self.config = config
        
        return config
    }

    // Expose method to load voice configuration through VoiceConfigurationManager
    func loadVoiceConfiguration(for voice: AddOnItem) async throws -> QuizSessionConfig? {
        let loadedConfig = try await voiceConfigurationManager.loadVoiceConfiguration(for: voice)
        self.config = loadedConfig // Assign the loaded configuration to the config property
        return loadedConfig
    }

    // Method to download questions
    func downloadQuestions() async throws -> [Question] {
        let url = URL(string: ConfigurationUrls.questionsRequestUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let questions = try JSONDecoder().decode([Question].self, from: data)
        return questions
    }

}
