//
//  ReadoutDownloader.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

//class ReadoutDownloader {
//    let fileManager = FileManager.default
//    let audioFolderName = "AudioFiles"
//
//    // MARK: - Initialize the audio folder
//    init() {
//        createAudioFolder()
//    }
//
//    // MARK: - Download QuestionAudioPackage
//    func downloadQuestionAudio<T: DownloadableQuestion>(for question: T, userId: String, narrator: String, language: String) async throws -> QuestionAudioPackage {
//        let networkService = NetworkService()
//        let audioPackage = try await networkService.fetchQuestionAudioPack(for: question as! QuestionV2, userId: userId, narrator: narrator, language: language)
//
//        // Decode and log any errors in the audio fields if present
//        if let questionScriptAudio = audioPackage.questionScriptAudio,
//           let decodedData = Data(base64Encoded: questionScriptAudio),
//           let decodedString = String(data: decodedData, encoding: .utf8),
//           decodedString.contains("error") {
//            decodeBase64Error(questionScriptAudio)
//            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error in questionScriptAudio"])
//        }
//
//        if let correctionAudio = audioPackage.correctionAudio,
//           let decodedData = Data(base64Encoded: correctionAudio),
//           let decodedString = String(data: decodedData, encoding: .utf8),
//           decodedString.contains("error") {
//            decodeBase64Error(correctionAudio)
//            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error in correctionAudio"])
//        }
//
//        if let repeatAudio = audioPackage.repeatAudio,
//           let decodedData = Data(base64Encoded: repeatAudio),
//           let decodedString = String(data: decodedData, encoding: .utf8),
//           decodedString.contains("error") {
//            decodeBase64Error(repeatAudio)
//            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error in repeatAudio"])
//        }
//
//        // Safely unwrap and save the audio files using ReadoutDownloader
//        if let questionScriptAudio = audioPackage.questionScriptAudio {
//            let _ = try saveAudioFile(base64Audio: questionScriptAudio, fileName: "questionScript")
//        }
//        
//        if let correctionAudio = audioPackage.correctionAudio {
//            let _ = try saveAudioFile(base64Audio: correctionAudio, fileName: "correction")
//        }
//        
//        if let repeatAudio = audioPackage.repeatAudio {
//            let _ = try saveAudioFile(base64Audio: repeatAudio, fileName: "repeat")
//        }
//
//        return audioPackage
//    }
//
//
//
//    func decodeBase64Error(_ base64String: String) {
//        if let data = Data(base64Encoded: base64String),
//           let decodedString = String(data: data, encoding: .utf8) {
//            print("Decoded Error Message: \(decodedString)")
//        } else {
//            print("Failed to decode base64 string.")
//        }
//    }
//
//
//    
//    // MARK: - Narrator Voice Selection
//    private func narratorVoiceSelection(narrator: String) -> String {
//        // Convert the string narrator to a VoiceSelector case
//        guard let selectedVoice = VoiceSelector(rawValue: narrator) else {
//            // Default to Gus if the narrator is not recognized
//            return VoiceSelector.gus.voiceDesignation
//        }
//        
//        // Return the voice designation for the selected narrator
//        return selectedVoice.voiceDesignation
//    }
//
//    
//    // MARK: - Create the folder in the File Manager for audio files
//    private func createAudioFolder() {
//        guard let audioFolderURL = getAudioFolderURL() else {
//            print("Error: Could not retrieve audio folder URL.")
//            return
//        }
//
//        if !fileManager.fileExists(atPath: audioFolderURL.path) {
//            do {
//                try fileManager.createDirectory(at: audioFolderURL, withIntermediateDirectories: true, attributes: nil)
//                print("Created folder for audio files at: \(audioFolderURL.path)")
//            } catch {
//                print("Error creating audio folder: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // MARK: - Save audio data to the current quiz folder
//    func saveAudioFile(base64Audio: String, fileName: String) throws -> URL? {
//        guard let audioData = Data(base64Encoded: base64Audio) else {
//            print("Error: Invalid base64 audio string.")
//            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid base64 string"])
//        }
//
//        guard let audioFolderURL = getAudioFolderURL() else {
//            print("Error: Could not retrieve audio folder URL.")
//            return nil
//        }
//
//        let fileURL = audioFolderURL.appendingPathComponent(fileName).appendingPathExtension("mp3")
//
//        do {
//            try audioData.write(to: fileURL)
//            print("Saved audio file at: \(fileURL.path)")
//            return fileURL
//        } catch {
//            print("Error saving audio file: \(error.localizedDescription)")
//            throw error
//        }
//    }
//
//    // MARK: - Retrieve the audio folder URL
//    private func getAudioFolderURL() -> URL? {
//        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//        return documentDirectory?.appendingPathComponent(audioFolderName)
//    }
//
//    // MARK: - Delete all audio files
//    func deleteAllAudioFiles() {
//        guard let audioFolderURL = getAudioFolderURL() else {
//            print("Error: Could not retrieve audio folder URL for deletion.")
//            return
//        }
//
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: audioFolderURL, includingPropertiesForKeys: nil, options: [])
//            for fileURL in fileURLs {
//                try fileManager.removeItem(at: fileURL)
//                print("Deleted audio file at: \(fileURL.path)")
//            }
//            print("All audio files deleted.")
//        } catch {
//            print("Error deleting audio files: \(error.localizedDescription)")
//        }
//    }
//}
