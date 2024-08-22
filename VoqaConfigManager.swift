//
//  VoqaConfigManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/11/24.
//

import Foundation
import FirebaseFirestore

class VoqaConfigManager: ObservableObject {
    var collections: [VoqaCollection] = []
    let networkService = NetworkService()
    
    func downloadConfig() async throws -> [VoqaCollection] {
        let data = try await networkService.downloadData(from: configUrls.homepageConfigUrl)
        let decoder = JSONDecoder()
        let voqaConfig = try decoder.decode(VoqaConfig.self, from: data)
        self.collections = voqaConfig.voqaCollection
        return voqaConfig.voqaCollection
    }
    
    func loadFromBundle(bundleFileName: String) async throws -> [VoqaCollection] {
        guard let url = Bundle.main.url(forResource: bundleFileName, withExtension: "json") else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found in bundle"])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let voqaConfig = try decoder.decode(VoqaConfig.self, from: data)
        self.collections = voqaConfig.voqaCollection
        return voqaConfig.voqaCollection
    }
    
    func loadImage(from imageUrl: String) async throws -> Data {
        let data = try await networkService.downloadData(from: imageUrl)
        return data
    }

    func updateFirebase(with quizArray: [[String: Any]]) {
        let db = Firestore.firestore()

        for quiz in quizArray {
            if let id = quiz["id"] as? String {
                var updatedQuiz = quiz
                updatedQuiz["accessToken"] = UUID().uuidString + id

                db.collection("quizzes").document(id).setData(updatedQuiz) { error in
                    if let error = error {
                        print("Error adding document with id \(id): \(error)")
                    } else {
                        print("Document with id \(id) added successfully!")
                    }
                }
            }
        }
    }
}

struct configUrls {
    static let homepageConfigUrl = "https://example.com/voqaCollection.json"
    static let getQuizCollection = "https://ljnsun.buildship.run/getQuizCollection"
}
