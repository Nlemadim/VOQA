//
//  DataService.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

// DataService class that conforms to DataFetchable and Downloadable protocols
class DataService: DataFetchable, Downloadable {
    typealias ModelType = Topic
    
    var id: UUID
    var downloadUrl: String
    
    init(id: UUID, downloadUrl: String) {
        self.id = id
        self.downloadUrl = downloadUrl
    }
    
    /// Fetch all data for a given model type
    /// - Parameter completion: Completion handler with Result containing either an array of ModelType or an Error
    func fetchAll(completion: @escaping (Result<[ModelType], Error>) -> Void) {
        NetworkService.shared.fetchAll(completion: completion)
    }
    
    /// Fetch data by ID for a given model type
    /// - Parameters:
    ///   - id: The ID of the model to fetch
    ///   - completion: Completion handler with Result containing either a ModelType or an Error
    func fetchById(_ id: UUID, completion: @escaping (Result<ModelType, Error>) -> Void) {
        NetworkService.shared.fetchById(id, completion: completion)
    }
    
    /// Download data by URL
    /// - Parameter completion: Completion handler with Result containing either Data or an Error
    func download(completion: @escaping (Result<Data, Error>) -> Void) {
        NetworkService.shared.queueDownloadTask {
            do {
                let data = try await NetworkService.shared.fetchAudioData(content: self.downloadUrl)
                completion(.success(data))
            } catch {
                completion(.failure(DatabaseError(message: "Failed to download data", errorType: .downloadError)))
            }
        }
    }
    
    /// Save audio data to a file
    /// - Parameter data: The audio data to save
    /// - Returns: The file name of the saved audio file, or nil if the operation fails
    private func saveAudioDataToFile(_ data: Data) -> String? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".mp3"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving audio file: \(error)")
            return nil
        }
    }
    
    /// Delete an audio file
    /// - Parameter fileName: The name of the audio file to delete
    private func deleteAudioFile(named fileName: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("Audio file deleted: \(fileName)")
        } catch {
            print("Error deleting audio file: \(error)")
        }
    }
}

// Extension to DataService to conform to AudioDownloadable protocol
extension DataService: AudioDownloadable {
    var audioUrl: String {
        return downloadUrl
    }
    
    /// Download audio data and save it to a file
    /// - Parameter completion: Completion handler with Result containing either the file URL of the saved audio file or an Error
    func downloadAudio(completion: @escaping (Result<URL, Error>) -> Void) {
        NetworkService.shared.queueAudioDownloadTask {
            do {
                let data = try await NetworkService.shared.fetchAudioData(content: self.audioUrl)
                guard let fileName = self.saveAudioDataToFile(data) else {
                    throw DatabaseError(message: "Failed to save audio data to file", errorType: .saveError)
                }
                let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
                completion(.success(fileURL))
            } catch {
                completion(.failure(DatabaseError(message: "Failed to download audio", errorType: .downloadError)))
            }
        }
    }
}
