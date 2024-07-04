//
//  NetworkService+Question+Ext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

// Question data fetching
extension NetworkService {
    /// Fetch all questions and decode them into Question models
    /// - Parameter completion: Completion handler with Result containing either array of Question or an Error
    func fetchAllQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        Task {
            do {
                let questions = try await fetchQuestionData(examName: "defaultExam", topics: ["defaultTopic"], number: 10) // Use appropriate parameters
                completion(.success(questions))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch a question by ID and decode it into a Question model
    /// - Parameters:
    ///   - id: The ID of the question to fetch
    ///   - completion: Completion handler with Result containing either a Question or an Error
    func fetchQuestionById(_ id: UUID, completion: @escaping (Result<Question, Error>) -> Void) {
        Task {
            do {
                // Fetch questions and filter by ID
                let questions = try await fetchQuestionData(examName: "defaultExam", topics: ["defaultTopic"], number: 1) // Use appropriate parameters
                if let question = questions.first(where: { $0.id == id }) {
                    completion(.success(question)) // Return the found question
                } else {
                    completion(.failure(NetworkError(message: "Question not found.")))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
