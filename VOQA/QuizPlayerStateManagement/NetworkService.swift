//
//  NetworkService.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/8/24.
//

import Foundation

class NetworkService {
    
    
    
    func fetchAudioUrl(for feedbackMessage: String) async throws -> String {
        let cleanedMessage = cleanMessage(feedbackMessage)
        let encodedMessage = cleanedMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(ConfigurationUrls.voiceFeedbackRequestUrl)?feedbackMessage=\(encodedMessage)"
        
        print("Fetching audio URL for message: \(feedbackMessage)")
        print("Encoded message: \(encodedMessage)")
        print("Request URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        } else {
            print("No valid HTTP response received")
        }

        let audioUrl = String(data: data, encoding: .utf8) ?? ""
        
        print("Downloaded audio URL: \(audioUrl)")
        
        return audioUrl
    }
    
    func downloadData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        print("Starting download from URL: \(urlString)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        }
        
        print("Download complete, data size: \(data.count) bytes")
        return data
    }
    

    
    private func cleanMessage(_ message: String) -> String {
        var cleanedMessage = message.replacingOccurrences(of: "\n", with: " ")
        cleanedMessage = cleanedMessage.replacingOccurrences(of: "\r", with: " ")
        cleanedMessage = cleanedMessage.replacingOccurrences(of: "\"", with: "'")
        cleanedMessage = cleanedMessage.replacingOccurrences(of: "!", with: "")
        return cleanedMessage
    }
}
