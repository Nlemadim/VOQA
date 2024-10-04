//
//  DynamicContentManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/2/24.
//

import Foundation
import SwiftUI
import Combine

final class DynamicContentManager: ObservableObject, SessionObserver, QuizServices {

    @Published var hasFetchedSessionIntro: Bool = false
    @Published var dynamicSessionIntro: FeedbackSfx? 
    
    private var config: QuizSessionConfig?
    var session: QuizSession?
    var observers: [SessionObserver] = []
    
    private var networkService = NetworkService()
    
    // MARK: - Configuration Method
    func configure(with config: QuizSessionConfig) {
        self.config = config
        print("DynamicContentManager registers config \(config.sessionId)")
    }
    
    // MARK: - Fetch Session Intro
    func getSessionIntro() async {
        guard  let config = config else { return }
        print("Content manager is Fetching session intro")
        
        do {
            //MARK: Test Session Intro Request
            //let sessionIntro = try await networkService.fetchCurrentSessionIntroTest()
            
            //MARK: Live Session Intro Request
            let sessionIntro = try await networkService.fetchCurrentSessionIntro(
                userId: config.sessionId.uuidString,
                quizTitle: config.sessionTitle,
                narratorId: config.sessionVoiceId ?? "UNKNOWN",
                questionIds: config.sessionQuestion.map{$0.id}
            )
            
            // Update the published property on the main thread
            await MainActor.run {
                self.dynamicSessionIntro = sessionIntro
                config.quizHostMessages?.quizSessionIntro.audioUrls.append(sessionIntro)
                self.hasFetchedSessionIntro = true
            }
        } catch {
            print("❌ Failed to fetch session intro: \(error.localizedDescription)")
            // Handle error as needed, e.g., set isSessionIntroFetched to false or show an alert
            //❌ Failed to fetch session intro: The operation couldn’t be completed. (NSURLErrorDomain error -1011.)
        }
    }
    
    func stateDidChange(to newState: any QuizServices) {
        
    }
        
    func handleState(session: QuizSession) {
        
    }
    
    func addObserver(_ observer: any SessionObserver) {
        
    }
    
    func notifyObservers() {
        
    }
    
}


extension NetworkService {
    
    // Original fetchCurrentSessionIntro method
    func fetchCurrentSessionIntro(userId: String, quizTitle: String, narratorId: String, questionIds: [String]) async throws -> FeedbackSfx {
        // Construct the URL
        guard let url = URL(string: ConfigurationUrls.dynamicSessioninfo) else {
            print("Failed to construct URL from: \(ConfigurationUrls.dynamicSessioninfo)")
            throw URLError(.badURL)
        }
        print("Constructed URL: \(url)")

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Set method to POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request method set to: \(request.httpMethod!)")
        print("Request headers: \(request.allHTTPHeaderFields ?? [:])")

        // Create the request body
        let requestBody: [String: Any] = [
            "userId": userId,
            "quizTitle": quizTitle,
            "narratorId": narratorId,
            "questionIds": questionIds
        ]
        
        // Encode the request body as JSON
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = bodyData
            print("Request body successfully encoded.")
            print("Request Body: \(String(data: bodyData, encoding: .utf8) ?? "Unable to encode body")")
        } catch {
            print("Failed to encode request body: \(error.localizedDescription)")
            throw error
        }

        // Perform the network request
        print("Performing network request...")
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check for HTTP response status
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Failed to cast response to HTTPURLResponse.")
            throw URLError(.badServerResponse)
        }

        print("HTTP Response Status Code: \(httpResponse.statusCode)")
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Received bad response: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }

        print("Received valid response, decoding data...")

        // Decode the JSON response into FeedbackSfx
        let decoder = JSONDecoder()
        do {
            let sessionIntro = try decoder.decode(FeedbackSfx.self, from: data)
            print("Successfully decoded session intro.")

            return sessionIntro
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Test Method for Dynamic Intro Data
    func fetchCurrentSessionIntroTest() async throws -> FeedbackSfx {
        let dynamicIntroData = """
        {
            "title": "dynamicSessionIntro",
            "urlScript": "Welcome to the NCLEX-RN quiz, a vital component of your preparation as an aspiring registered nurse. This quiz presents a set of 10 questions that delve into essential topics such as Safe and Effective Care Environment, Health Promotion and Maintenance, Psychosocial Integrity, and Physiological Integrity. As you work through these questions, you will have the opportunity to assess and hone your knowledge across these critical domains. This exercise is designed to help you identify your strengths and uncover areas that may benefit from additional study, ultimately guiding you toward success on the NCLEX-RN examination. Let's embark on this important step in your nursing journey!",
            "audioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/CurrentQuizSession/rfsvshgvsdfngdhdjkdkd/sessionIntro.mp3"
        }
        """
        
        // Decode the static JSON data
        let data = dynamicIntroData.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        do {
            let sessionIntro = try decoder.decode(FeedbackSfx.self, from: data)
            print("Successfully decoded session intro from test data.")
            return sessionIntro
        } catch {
            print("Decoding error from test data: \(error.localizedDescription)")
            throw error
        }
    }
}
