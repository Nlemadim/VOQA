//
//  DatabaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()

    @Published var currentError: DatabaseError?
    @Published var showFullPageError: Bool = false
    private var dataService: DataService?
    
    private init() {}

    func setupDataService(id: UUID, downloadUrl: String) {
        self.dataService = DataService(id: id, downloadUrl: downloadUrl)
    }

    func fetchAllTopics(completion: @escaping (Result<[Topic], Error>) -> Void) {
        guard let dataService = dataService else {
            completion(.failure(DatabaseError(message: "DataService not initialized", errorType: .downloadError)))
            return
        }
        dataService.fetchAll(completion: completion)
    }

    func fetchTopicById(_ id: UUID, completion: @escaping (Result<Topic, Error>) -> Void) {
        guard let dataService = dataService else {
            completion(.failure(DatabaseError(message: "DataService not initialized", errorType: .downloadError)))
            return
        }
        dataService.fetchById(id, completion: completion)
    }

    func downloadAudio(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let dataService = dataService else {
            completion(.failure(DatabaseError(message: "DataService not initialized", errorType: .downloadError)))
            return
        }
        dataService.downloadAudio(completion: completion)
    }


    func handleError(_ error: DatabaseError) {
        self.currentError = error
        if let errorType = error.errorType {
            switch errorType {
            case .databaseError(let dbError):
                switch dbError {
                case .downloadError, .saveError:
                    self.showFullPageError = false
                case .accessError:
                    self.showFullPageError = true
                }
            case .connectionError:
                // Handle connection errors if necessary
                break
            default:
                break
            }
        }
    }
}



extension DatabaseManager {
    
    func downloadVoiceFeedbackMessages(container: VoiceFeedbackContainer, completion: @escaping (Result<VoiceFeedbackMessages, Error>) -> Void) {
        
        guard let dataService = dataService else {
            completion(.failure(DatabaseError(message: "DataService not initialized", errorType: .downloadError)))
            return
        }
        
        let group = DispatchGroup()
        var downloadResults: [Result<URL, Error>] = []
        
        let downloadTask: (String) -> Void = { url in
            group.enter()
            dataService.downloadAudio { result in
                downloadResults.append(result)
                group.leave()
            }
        }
        
        let urls = [
            container.quizStartAudioUrl,
            container.quizEndingAudioUrl,
            container.nextQuestionCalloutAudioUrl,
            container.finalQuestionCalloutAudioUrl,
            container.repeatQuestionCalloutAudioUrl,
            container.listeningCalloutAudioUrl,
            container.waitingForResponseCalloutAudioUrl,
            container.pausedCalloutAudioUrl,
            container.correctAnswerCalloutAudioUrl,
            container.correctAnswerLowStreakCallOutAudioUrl,
            container.correctAnswerMidStreakCalloutAudioUrl,
            container.correctAnswerHighStreakCalloutAudioUrl,
            container.inCorrectAnswerCalloutAudioUrl,
            container.zeroScoreCommentAudioUrl,
            container.tenPercentScoreCommentAudioUrl,
            container.twentyPercentScoreCommentAudioUrl,
            container.thirtyPercentScoreCommentAudioUrl,
            container.fortyPercentScoreCommentAudioUrl,
            container.fiftyPercentScoreCommentAudioUrl,
            container.sixtyPercentScoreCommentAudioUrl,
            container.seventyPercentScoreCommentAudioUrl,
            container.eightyPercentScoreCommentAudioUrl,
            container.ninetyPercentScoreCommentAudioUrl,
            container.perfectScoreCommentAudioUrl,
            container.errorTranscriptionAudioUrl,
            container.invalidResponseCalloutAudioUrl,
            container.invalidResponseUserAdvisoryAudioUrl
        ]
        
        for url in urls {
            downloadTask(url)
        }
        
        group.notify(queue: .main) {
            let errors = downloadResults.compactMap { result -> Error? in
                if case .failure(let error) = result {
                    return error
                }
                return nil
            }
            
            if let firstError = errors.first {
                completion(.failure(firstError))
                return
            }
            
            // Populate VoiceFeedbackMessages
            let messages = VoiceFeedbackMessages(
                quizStartScript: container.quizStartMessageScript,
                quizEndingScript: container.quizEndingMessageScript,
                nextQuestionCalloutScript: container.nextQuestionCalloutScript,
                finalQuestionCalloutScript: container.finalQuestionCalloutScript,
                repeatQuestionCalloutScript: container.repeatQuestionCalloutScript,
                listeningCalloutScript: container.listeningCalloutScript,
                waitingForResponseCalloutScript: container.waitingForResponseCalloutScript,
                pausedCalloutScript: container.pausedCalloutScript,
                correctAnswerCalloutScript: container.correctAnswerCalloutScript,
                correctAnswerLowStreakCallOutScript: container.correctAnswerLowStreakCallOutScript,
                correctAnswerMidStreakCalloutScript: container.correctAnswerMidStreakCalloutScript,
                correctAnswerHighStreakCalloutScript: container.correctAnswerHighStreakCalloutScript,
                inCorrectAnswerCalloutScript: container.inCorrectAnswerCalloutScript,
                zeroScoreCommentScript: container.zeroScoreCommentScript,
                tenPercentScoreCommentScript: container.tenPercentScoreCommentScript,
                twentyPercentScoreCommentScript: container.twentyPercentScoreCommentScript,
                thirtyPercentScoreCommentScript: container.thirtyPercentScoreCommentScript,
                fortyPercentScoreCommentScript: container.fortyPercentScoreCommentScript,
                fiftyPercentScoreCommentScript: container.fiftyPercentScoreCommentScript,
                sixtyPercentScoreCommentScript: container.sixtyPercentScoreCommentScript,
                seventyPercentScoreCommentScript: container.seventyPercentScoreCommentScript,
                eightyPercentScoreCommentScript: container.eightyPercentScoreCommentScript,
                ninetyPercentScoreCommentScript: container.ninetyPercentScoreCommentScript,
                perfectScoreCommentScript: container.perfectScoreCommentScript,
                errorTranscriptionScript: container.errorTranscriptionScript,
                invalidResponseCalloutScript: container.invalidResponseCalloutScript,
                invalidResponseUserAdvisoryScript: container.invalidResponseUserAdvisoryScript,
                quizStartAudioUrl: container.quizStartAudioUrl,
                quizEndingAudioUrl: container.quizEndingAudioUrl,
                nextQuestionCalloutAudioUrl: container.nextQuestionCalloutAudioUrl,
                finalQuestionCalloutAudioUrl: container.finalQuestionCalloutAudioUrl,
                repeatQuestionCalloutAudioUrl: container.repeatQuestionCalloutAudioUrl,
                listeningCalloutAudioUrl: container.listeningCalloutAudioUrl,
                waitingForResponseCalloutAudioUrl: container.waitingForResponseCalloutAudioUrl,
                pausedCalloutAudioUrl: container.pausedCalloutAudioUrl,
                correctAnswerCalloutAudioUrl: container.correctAnswerCalloutAudioUrl,
                correctAnswerLowStreakCallOutAudioUrl: container.correctAnswerLowStreakCallOutAudioUrl,
                correctAnswerMidStreakCalloutAudioUrl: container.correctAnswerMidStreakCalloutAudioUrl,
                correctAnswerHighStreakCalloutAudioUrl: container.correctAnswerHighStreakCalloutAudioUrl,
                inCorrectAnswerCalloutAudioUrl: container.inCorrectAnswerCalloutAudioUrl,
                zeroScoreCommentAudioUrl: container.zeroScoreCommentAudioUrl,
                tenPercentScoreCommentAudioUrl: container.tenPercentScoreCommentAudioUrl,
                twentyPercentScoreCommentAudioUrl: container.twentyPercentScoreCommentAudioUrl,
                thirtyPercentScoreCommentAudioUrl: container.thirtyPercentScoreCommentAudioUrl,
                fortyPercentScoreCommentAudioUrl: container.fortyPercentScoreCommentAudioUrl,
                fiftyPercentScoreCommentAudioUrl: container.fiftyPercentScoreCommentAudioUrl,
                sixtyPercentScoreCommentAudioUrl: container.sixtyPercentScoreCommentAudioUrl,
                seventyPercentScoreCommentAudioUrl: container.seventyPercentScoreCommentAudioUrl,
                eightyPercentScoreCommentAudioUrl: container.eightyPercentScoreCommentAudioUrl,
                ninetyPercentScoreCommentAudioUrl: container.ninetyPercentScoreCommentAudioUrl,
                perfectScoreCommentAudioUrl: container.perfectScoreCommentAudioUrl,
                errorTranscriptionAudioUrl: container.errorTranscriptionAudioUrl,
                invalidResponseCalloutAudioUrl: container.invalidResponseCalloutAudioUrl,
                invalidResponseUserAdvisoryAudioUrl: container.invalidResponseUserAdvisoryAudioUrl
            )
            
            completion(.success(messages))
        }
    }
}
