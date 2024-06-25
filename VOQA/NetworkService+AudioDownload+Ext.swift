//
//  NetworkService+AudioDownload+Ext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

extension NetworkService {
    
    /// Fetch audio data for the provided content
    /// - Parameter content: The content to fetch audio data for
    /// - Returns: Audio data
    func fetchAudioData(content: String) async throws -> Data {
        var components = URLComponents(string: Config.audioRequestURL)
        components?.queryItems = [
            URLQueryItem(name: "content", value: content)
        ]
        
        guard let apiURL = components?.url else {
            throw NetworkError(message: "Invalid URL provided.")
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError(message: "Server returned an invalid status code.")
        }
        
        guard let decodedData = Data(base64Encoded: data) else {
            throw NetworkError(message: "Failed to decode the response data.")
        }
        
        return decodedData
    }
    
    /// Queue an audio download task to prevent multiple concurrent downloads
    /// - Parameter task: The download task to queue
    func queueAudioDownloadTask(_ task: @escaping () async throws -> Void) {
        downloadQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.isDownloading {
                Task {
                    do {
                        try await task()
                    } catch {
                        print("Audio download task failed with error: \(error)")
                    }
                }
            } else {
                self.isDownloading = true
                Task {
                    defer { self.isDownloading = false }
                    do {
                        try await self.performDownloadTask(task)
                    } catch {
                        print("Audio download task failed with error: \(error)")
                    }
                }
            }
        }
    }
}
