//
//  DynamicContentManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/2/24.
//

import Foundation
import SwiftUI

protocol SessionConfigurable {
    func fetchCurrentSessionIntro() async throws
}

struct DynamicSessionInfoRequest {
    var id: String,
    var quizTitle: String,
    var narrator: String,
    var questionIds: [String]
    
}

class DynamicContentManager {
    @Published var isSessionIntroFetched: Bool = false
    
    var session: QuizSession?
    private var config: QuizSessionConfig?
    private var networkService = NetworkService()
    
    
    

    
    func configure(with config: QuizSessionConfig) {
        self.config = config
    }
}


//extension DatabaseManager: SessionConfigurable {}
//let sessionIntro = try await networkService.fetchCurrentSessionIntro(
//    userId: config.userId,
//    quizTitle: sessionConfig.sessionTitle,
//    narrator: sessionConfig.sessionVoiceId ?? "UNKNOWN", // Ensure a valid voice ID is passed
//    questionIds: newQuestions.map { $0.id }
//)
//
//quizHostMessages.quizSessionIntro.audioUrls = sessionIntro.audioUrls
//
//if quizHostMessages.quizSessionIntro.title.isEmptyOrWhiteSpace {
//    quizHostMessages.quizSessionIntro.title = "dynamicSessionIntro"
//}
