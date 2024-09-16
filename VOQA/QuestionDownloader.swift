//
//  QuestionDownloader.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/10/24.
//

import SwiftUI
import AVKit

struct QuestionListView: View {
    @State private var questions: [QuestionV2] = []
    @State private var audioPlayer: AVPlayer? = nil
    
    // Access the UserConfig object from the environment
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        if questions.isEmpty {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                        .foregroundStyle(.white.opacity(0.8))
                    Spacer()
                }
                .onAppear {
                   fetchQuestions()
                }
            }
        } else {
            List(questions, id: \.refId) { question in
                VStack(alignment: .leading, spacing: 10) {
                    // Question content
                    Text(question.content)
                        .font(.headline)
                    
                    // Play buttons for questionScriptAudio and correctionAudio
                    HStack {
                        Button(action: {
                            playAudio(urlString: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_questionScript.mp3")
                        }) {
                            Text("Play Script")
                                .frame(width: 120, height: 40)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            playAudio(urlString:  "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_repeatQuestionScript.mp3")
                        }) {
                            Text("Play Correction")
                                .frame(width: 120, height: 40)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            
        }
    }
    
    // Function to play audio from a URL
    private func playAudio(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }
    
    // Function to fetch questions and update state
    private func fetchQuestions()  {
       databaseManager.fetchProcessedQuestions("Data Privacy", maxNumberOfQuestions: 5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.questions.append(contentsOf: databaseManager.questionsV2)
        }
    }
}


#Preview {
    let dbMgr = DatabaseManager.shared
    return QuestionListView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
    
}

struct FakeConfig {
    let userId: String
    let quizTitle: String
    let narrator: String
    let language: String
    
    init(userId: String, quizTitle: String, narrator: String, language: String) {
        self.userId = userId
        self.quizTitle = quizTitle
        self.narrator = narrator
        self.language = language
    }
}

class QuestionDownloader {
    let networkService = NetworkService()
    //var config: UserConfig
    var config: FakeConfig
    
    // Initialize QuestionDownloader with a UserConfig
    init(config: FakeConfig) {
        self.config = config
    }
    
    // MARK: - Expose a public method to download quiz questions
    func downloadQuizQuestions(quizTitle: String, maxNumberOfQuestions: Int?) async throws -> [QuestionV2] {
        let requestBody = QuestionRequestBody(
            userId: "bkjdjndkjwkjndkjwn",
            quizTitle: "MCAT",
            request: "All Categories",
            narrator: narratorVoiceSelection(narrator: "Gus"),
            numberOfQuestions: maxNumberOfQuestions ?? 5
        )
        let questions = try await fetchQuestions(requestBody: requestBody)
        return questions
    }

    // MARK: - Private: Fetch Questions and manage audio download
    private func fetchQuestions(requestBody: QuestionRequestBody) async throws -> [QuestionV2] {
        print("Starting Download")
        let questions = try await networkService.fetchQuestionsV2(requestBody: requestBody)

        let processedQuestions = questions

        return processedQuestions
    }
    
    private func narratorVoiceSelection(narrator: String) -> String {
        // Convert the string narrator to a VoiceSelector case
        guard let selectedVoice = VoiceSelector(rawValue: narrator) else {
            // Default to Gus if the narrator is not recognized
            return VoiceSelector.gus.voiceDesignation
        }
        
        // Return the voice designation for the selected narrator
        return selectedVoice.voiceDesignation
    }

}



extension NetworkService {

    // MARK: - Fetch Questions V2 with request body
    func fetchQuestionsV2(requestBody: QuestionRequestBody) async throws -> [QuestionV2] {
        print("Fetching questions V2 from URL: \(ConfigurationUrls.testQuestionsDownload)")

        // Prepare the URL and request
        guard let url = URL(string: ConfigurationUrls.testQuestionsDownload) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode the request body
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            request.httpBody = bodyData
            print("Request body successfully encoded.")
            print("Request Body: \(String(data: bodyData, encoding: .utf8) ?? "Unable to encode body")")
        } catch {
            print("Failed to encode request body: \(error)")
            throw error
        }

        // Make the network call
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }

            print("Received raw data size: \(data.count) bytes")

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            } else {
                print("Unable to convert data to string for debugging")
            }

            if data.count == 0 {
                print("Received empty data from the server.")
                throw URLError(.zeroByteResource)
            }

            print("Attempting to decode response data into QuestionV2 models...")

            let questions = try JSONDecoder().decode([QuestionV2].self, from: data)

            print("Successfully decoded \(questions.count) questions V2.")
            print("Decoded questions: \(questions)")  // Print the decoded data

            return questions

        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError.localizedDescription)")
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted error: \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("Key not found: \(key.stringValue), \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type), \(context.debugDescription)")
            case .valueNotFound(let value, let context):
                print("Value not found: \(value), \(context.debugDescription)")
            default:
                print("Unknown decoding error.")
            }
            throw decodingError
        } catch {
            print("Network or other error: \(error.localizedDescription)")
            throw error
        }
    }
}
