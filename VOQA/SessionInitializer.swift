//
//  SessionInitializer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/9/24.
//

import Foundation

class SessionInitializer {
    private let config: QuizSessionConfig
    
    init(config: QuizSessionConfig) {
        self.config = config
    }
    
    func initializeSession() -> QuizSessionInfoProtocol {
        return QuizSessionInfo(
            sessionTitle: config.sessionTitle,
            sessionQuestions: config.sessionQuestion
        )
    }
    
    func initializeAudioFileSorter() -> QuizSessionConfig {
        return config
    }
}


struct QuizSessionInfo: QuizSessionInfoProtocol {
    var sessionTitle: String
    var sessionQuestions: [Question]
}
