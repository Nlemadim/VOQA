//
//  NetworkServe+Topic+Ext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

extension NetworkService: DataFetchable {
    typealias ModelType = Topic
    
    /// Fetch all topics and decode them into Topic models
    /// - Parameter completion: Completion handler with Result containing either array of Topic or an Error
    func fetchAll(completion: @escaping (Result<[Topic], Error>) -> Void) {
        Task {
            do {
                let topics = try await fetchTopics(context: "defaultContext") // Use appropriate context
                
                // Assuming API returns array of dictionaries
                let decodedTopics = try topics.map { topicData -> Topic in
                    guard let topicIdString = topicData["id"] as? String,
                          let topicId = UUID(uuidString: topicIdString),
                          let topicTitle = topicData["title"] as? String,
                          let categoryInt = topicData["category"] as? Int,
                          let topicCategory = TopicCategory(rawValue: categoryInt),
                          let learningIndex = topicData["learningIndex"] as? Int,
                          let presentations = topicData["presentations"] as? Int else {
                        throw NetworkError(message: "Invalid topic data.")
                    }
                    
                    let progress = topicData["progress"] as? Double ?? 0.0
                    
                    return Topic(
                        topicId: topicId,
                        topicTitle: topicTitle,
                        topicCategory: topicCategory,
                        learningIndex: learningIndex,
                        presentations: presentations,
                        dateLastPresented: nil, // This will be set by the app later
                        progress: progress
                    )
                }
                completion(.success(decodedTopics))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch a topic by ID and decode it into a Topic model
    /// - Parameters:
    ///   - id: The ID of the topic to fetch
    ///   - completion: Completion handler with Result containing either a Topic or an Error
    func fetchById(_ id: UUID, completion: @escaping (Result<Topic, Error>) -> Void) {
        Task {
            do {
                let topics = try await fetchTopics(context: "defaultContext") // Use appropriate context
                if let topicData = topics.first(where: { UUID(uuidString: $0["id"] as? String ?? "") == id }) {
                    guard let topicTitle = topicData["title"] as? String,
                          let categoryInt = topicData["category"] as? Int,
                          let topicCategory = TopicCategory(rawValue: categoryInt),
                          let learningIndex = topicData["learningIndex"] as? Int,
                          let presentations = topicData["presentations"] as? Int else {
                        throw NetworkError(message: "Invalid topic data.")
                    }
                    
                    let progress = topicData["progress"] as? Double ?? 0.0
                    
                    let topic = Topic(
                        topicId: id,
                        topicTitle: topicTitle,
                        topicCategory: topicCategory,
                        learningIndex: learningIndex,
                        presentations: presentations,
                        dateLastPresented: nil, // This will be set by the app later
                        progress: progress
                    )
                    completion(.success(topic))
                } else {
                    completion(.failure(NetworkError(message: "Topic not found.")))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

