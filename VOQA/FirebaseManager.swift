//
//  FirebaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//

import Foundation
import FirebaseFirestore
import Combine

struct QuizCatalogueData {
    var categoryName: String
    var quizzes: [QuizDataStruct]
    
}

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    
    // Holds the cached quiz catalogue data
    @Published var quizCatalogue: [QuizCatalogueData] = []
    
    private init() {
        configureFirestorePersistence()
    }
    
    private func configureFirestorePersistence() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    // Fetch Quiz Catalogue from Firebase
    func fetchQuizCatalogue() async throws -> [QuizCatalogueData] {
        print("Starting to fetch the quiz catalogue from Firebase...")
        
        let catalogueRef = db.collection("voqa_catalogue").document("nNIARO0aAQV6S9MzZ2Fx")
        var quizCatalogueData = [QuizCatalogueData]()
        
        do {
            let documentSnapshot = try await catalogueRef.getDocument()
            if let documentData = documentSnapshot.data(), let rawCatalogue = documentData["voqa_catalogue"] as? [String: [String: Any]] {
                print("Catalogue fetched successfully: \(documentData)")
                
                // Parse the raw catalogue data into QuizCatalogueData
                for (categoryName, categoryDetails) in rawCatalogue {
                    let quizzes = categoryDetails["quizzes"] as? [[String: String]] ?? []
                    let quizDataList = quizzes.compactMap { quiz -> QuizDataStruct? in
                        guard let quizId = quiz["quizId"], let quizTitle = quiz["title"] else { return nil }
                        return QuizDataStruct(
                            id: quizId,
                            coreTopics: [],
                            about: "",
                            generalTopics: [],
                            quizTitle: quizTitle,
                            imageUrl: "",
                            colors: ThemeColors(main: "", sub: "", third: ""),
                            curator: nil,
                            ratings: 0,
                            users: 0,
                            catalogueGroup: nil,
                            acronym: nil
                        )
                    }
                    let categoryData = QuizCatalogueData(categoryName: categoryName, quizzes: quizDataList)
                    quizCatalogueData.append(categoryData)
                }
            } else {
                print("No catalogue data found for the document.")
            }
        } catch {
            print("Error fetching catalogue: \(error.localizedDescription)")
            throw error
        }
        
        self.quizCatalogue = quizCatalogueData
        return quizCatalogueData
    }
    
    // Upload a Single Quiz Document to Firebase
    func uploadQuizDocumentToFirebase(quiz: QuizDataStruct) async throws {
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
    func fetchQuizCollection() async throws -> [QuizDataStruct] {
        print("Starting to fetch the quiz collection from the backend...")
        
        guard let url = URL(string: "https://ljnsun.buildship.run/getQuizCollection") else {
            print("Invalid URL for fetching quiz collection.")
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Data successfully fetched from the backend.")
            
            let quizCollection = try JSONDecoder().decode([QuizDataStruct].self, from: data)
            print("Quiz collection successfully decoded into QuizDataStruct.")
            
            // For visibility, print out one item from the fetched collection
            if let firstItem = quizCollection.first {
                print("First quiz item fetched: \(firstItem)")
            } else {
                print("No items found in the fetched quiz collection.")
            }
            
            return quizCollection
            
        } catch {
            print("Error fetching or decoding quiz collection: \(error.localizedDescription)")
            throw error
        }
    }
}
