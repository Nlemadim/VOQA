//
//  DownloadableQuestion.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

protocol DownloadableQuestion {
    var questionScript: String { get }
    var correction: String { get }
    var content: String { get }
    
    var questionScriptAudioUrl: String? { get set }
    var correctionAudioUrl: String? { get set }
    var repeatQuestionAudioUrl: String? { get set }
    
    func downloadAudio(for userId: String, narrator: String, language: String) async throws -> QuestionAudioPackage
    mutating func assignAudioUrls(from audioPackage: QuestionAudioPackage)
}
