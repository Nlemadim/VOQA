//
//  DatabaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import Combine

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    @Published var currentError: DatabaseError?
    @Published var showFullPageError: Bool = false
    @Published var questions: [Question] = []
    private var networkService = NetworkService()

    private init() {}

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
    
    func fetchQuestions() async {
        print("Database fetching Questions")
        do {
            let downloadedQuestions = try await networkService.fetchQuestions()
            //networkService.printQuestionUrls(questions: questions)
            DispatchQueue.main.async {
                self.questions = downloadedQuestions
            }
            print("Questions fetched successfully: \(questions.count) questions.")
        } catch {
            print("Error fetching questions: \(error)")
        }
    }
}
