//
//  NetworkService.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    var downloadQueue = DispatchQueue(label: "com.quizapp.downloadQueue", attributes: .concurrent)
    var isDownloading = false
    
    private init() {}
    
    /// Fetch topics based on the provided context
    /// - Parameter context: The context to filter topics
    /// - Returns: An array of topics as dictionaries
    func fetchTopics(context: String) async throws -> [[String: Any]] {
        let baseUrl = Config.topicRequestURL
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw NetworkError(message: "Invalid URL provided.")
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "context", value: context)]
        
        guard let url = urlComponents.url else {
            throw NetworkError(message: "Unable to construct a valid URL.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw NetworkError(message: "HTTP Error: \(httpResponse.statusCode)")
            }
            
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]]
            
            guard let topics = jsonResponse?["topics"] else {
                throw NetworkError(message: "Key 'topics' not found in response.")
            }
            
            return topics
        } catch {
            throw NetworkError(message: error.localizedDescription)
        }
    }
    
    /// Fetch question data for the provided parameters
    /// - Parameters:
    ///   - examName: The name of the exam
    ///   - topics: A list of topics
    ///   - number: The number of questions
    /// - Returns: An array of `Question` objects
    func fetchQuestionData(examName: String, topics: [String], number: Int) async throws -> [Question] {
        var questionDataObjects: [Question] = []
        let baseUrl = Config.questionsRequestURL
        let session = URLSession.shared
        
        for topic in topics {
            var urlComponents = URLComponents(string: baseUrl)!
            urlComponents.queryItems = [
                URLQueryItem(name: "nameValue", value: examName),
                URLQueryItem(name: "topicValue", value: topic),
                URLQueryItem(name: "numberValue", value: String(number))
            ]
            
            guard let url = urlComponents.url else {
                throw NetworkError(message: "Failed to create URL from components.")
            }
            
            do {
                let (data, response) = try await session.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError(message: "Received non-200 response.")
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                
                do {
                    let decodedResponse = try decoder.decode(Question.self, from: data)
                    questionDataObjects.append(decodedResponse)
                } catch {
                    throw NetworkError(message: "Failed to decode response to Question object.")
                }
            } catch {
                throw NetworkError(message: "Request to \(url.absoluteString) failed.")
            }
        }
        
        return questionDataObjects
    }
    
    /// Download tasks with retry logic and error handling
    /// - Parameters:
    ///   - task: The download task to perform
    ///   - retryCount: Number of retries
    /// - Returns: Result of the download task
    func performDownloadTask<T>(_ task: @escaping () async throws -> T, retryCount: Int = 3) async throws -> T {
        var attempts = 0
        var lastError: Error?
        
        while attempts < retryCount {
            do {
                return try await task()
            } catch {
                lastError = error
                attempts += 1
                if attempts < retryCount {
                    try await Task.sleep(nanoseconds: 2 * UInt64(attempts) * NSEC_PER_SEC)
                }
            }
        }
        
        throw lastError ?? NetworkError(message: "An unknown error occurred.")
    }
    
    /// Queue a download task to prevent multiple concurrent downloads
    /// - Parameter task: The download task to queue
    func queueDownloadTask(_ task: @escaping () async throws -> Void) {
        downloadQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.isDownloading {
                // Instead of using sync, we can directly call Task here to avoid the warning.
                Task {
                    do {
                        try await task()
                    } catch {
                        print("Download task failed with error: \(error)")
                    }
                }
            } else {
                self.isDownloading = true
                Task {
                    defer { self.isDownloading = false }
                    do {
                        try await self.performDownloadTask(task)
                    } catch {
                        print("Download task failed with error: \(error)")
                    }
                }
            }
        }
    }
}
