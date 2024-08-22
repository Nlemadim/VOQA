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
    var quizzes: [QuizData]
}

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    
    // Holds the cached quiz collection data
    @Published var quizCollection: [QuizData] = []
    
    private init() {
        configureFirestorePersistence()
    }
    
    private func configureFirestorePersistence() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }

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

    // Create Quiz Catalogue Locally
    func createQuizCatalogue(from quizCollection: [QuizData]) -> [QuizCatalogue] {
        let assignments: [String: [String]] = [
            "Arts and Humanities": ["World War 1 History", "English Language Arts", "Advanced Placement Exam", "American History"],
            "Most Popular College Admission Exams": ["SAT", "MCAT (Medical College Admission Test)", "TOEFL (Test of English as a Foreign Language)", "Advanced Placement Exam", "General Chemistry"],
            "Most Popular Professional Certifications and Exams": ["MBE (Multistate Bar Examination)", "CPA (Certified Public Accountant)", "CYSA (Cybersecurity Analyst)", "Real Estate Licensing", "CompTIA A+"],
            "Innovators' Hub (Tech and Innovation)": ["Kotlin Programming Language", "CCNA (Cisco Certified Network Associate)", "CompTIA A+", "CYSA (Cybersecurity Analyst)", "Privacy Engineering Principles"],
            "Top Picks": ["SAT", "MCAT (Medical College Admission Test)", "CPA (Certified Public Accountant)", "CCNA (Cisco Certified Network Associate)", "CYSA (Cybersecurity Analyst)", "TOEFL (Test of English as a Foreign Language)", "World War 1 History", "MBE (Multistate Bar Examination)", "General Physics", "Advanced Placement Exam"]
        ]

        let descriptions: [String: String] = [
            "Arts and Humanities": "Explore the rich history and diverse cultural expressions of humanity.",
            "Most Popular College Admission Exams": "Prepare for the most important college admission exams with our comprehensive quizzes.",
            "Most Popular Professional Certifications and Exams": "Enhance your career with top certifications and professional exams.",
            "Innovators' Hub (Tech and Innovation)": "Dive into the world of technology and innovation with these quizzes.",
            "Top Picks": "Our top selections of quizzes across various categories."
        ]
        
        var quizCatalogue = [QuizCatalogue]()
        
        for (categoryName, quizTitles) in assignments {
            var quizzesInCategory: [Voqa] = []
            
            for quiz in quizCollection {
                if quizTitles.contains(quiz.quizTitle) {
                    quizzesInCategory.append(Voqa(from: quiz))
                }
            }
            
            let categoryData = QuizCatalogue(
                categoryName: categoryName,
                quizzes: quizzesInCategory
            )
            quizCatalogue.append(categoryData)
        }
        
        return quizCatalogue
    }
}

