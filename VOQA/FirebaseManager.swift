//
//  FirebaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//


import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth
import AuthenticationServices
import CryptoKit



final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    
    // Holds the cached quiz collection data
    @Published var quizCollection: [QuizData] = []
    
//    private init() {
//        configureFirestorePersistence()
//    }
//    
//    private func configureFirestorePersistence() {
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = true
//        db.settings = settings
//    }
    
    // Upload a Single Quiz Document to Firebase
    func uploadQuizDocumentToFirebase(quiz: QuizData) async throws {
        print("Starting to upload quiz document to Firebase for quiz: \(quiz.quizTitle)")
        
        let quizData: [String: Any] = [
            "id": quiz.id,
            "coreTopics": quiz.coreTopics,
            "about": quiz.about,
            "generalTopics": quiz.generalTopics,
            "quizTitle": quiz.quizTitle,
            "imageUrl": quiz.imageUrl,
            "colors": [
                "main": quiz.colors.main,
                "sub": quiz.colors.sub,
                "third": quiz.colors.third
            ],
            "curator": quiz.curator ?? "",
            "ratings": quiz.ratings,
            "users": quiz.users,
            "catalogueGroup": quiz.catalogueGroup ?? "",
            "acronym": quiz.acronym ?? ""
        ]
        
        do {
            let documentID = quiz.id
            try await db.collection("quizzes").document(documentID).setData(quizData)
            print("Document added successfully for quiz: \(quiz.quizTitle)")
        } catch {
            print("Error uploading quiz document to Firebase: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Fetch Quiz Collection from Backend
    func fetchQuizCollection() async throws -> [QuizData] {
        print("Starting to fetch the quiz collection from the backend...")
        
        guard let url = URL(string: "https://ljnsun.buildship.run/getQuizCollection") else {
            print("Invalid URL for fetching quiz collection.")
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Data successfully fetched from the backend.")
            
            let quizCollection = try JSONDecoder().decode([QuizData].self, from: data)
            print("Quiz collection successfully decoded into QuizDataStruct.")
            
            // For visibility, print out one item from the fetched collection
            if let firstItem = quizCollection.first {
                print("First quiz item fetched: \(firstItem)")
            } else {
                print("No items found in the fetched quiz collection.")
            }
            
            self.quizCollection = quizCollection
            return quizCollection
            
        } catch {
            print("Error fetching or decoding quiz collection: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Sign-In with Apple using Firebase
    func loginWithFirebase(authorization: ASAuthorization, nonce: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion(.failure(NSError(domain: "Unable to fetch identity token", code: 0, userInfo: nil)))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Unable to serialize token string", code: 0, userInfo: nil)))
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            completion(.failure(NSError(domain: "Invalid Credential", code: 0, userInfo: nil)))
        }
    }
}

