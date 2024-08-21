//
//  HomepageViewmodel.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/20/24.
//

import SwiftUI
import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

class HomePageViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var quizCatalogue: [VoqaCollection] = []
    @Published var cachedImages: [String: Data] = [:]
    
    // MARK: - Firestore References
    private let db = Firestore.firestore()
    
    // MARK: - Methods
    
    func updateVoqaCatalogue() {
        Task {
            do {
                print("Starting the process to update the voqa_catalogue...")
                
                // Fetch the current quiz collection
                let quizCollection = try await fetchQuizCollection()
                print("Quiz collection fetched successfully.")
                
                // Fetch the current quiz catalogue
                let catalogue = try await fetchQuizCatalogue()
                print("Quiz catalogue fetched successfully.")
                
                // Upload a sample quiz document to Firebase
                if let firstQuiz = quizCollection.first {
                    try await uploadQuizDocumentToFirebase(quiz: firstQuiz)
                    print("Sample quiz document uploaded successfully.")
                }
                
                // Create and assign quizzes to the catalogue, get the quizCatalogueData for display
                let quizCatalogueData = try await createAndAssignQuizzesToCatalogue(quizCollection: quizCollection)
                print("Catalogue updated with assigned quizzes.")
                
                // Prepare the updated catalogue for upload
                let updatedCatalogue = prepareUpdatedCatalogueForUpload(quizCatalogueData: quizCatalogueData)
                
                // Upload the updated catalogue to Firebase
                try await uploadUpdatedCatalogueToFirebase(updatedCatalogue: updatedCatalogue)
                print("Updated catalogue uploaded successfully to Firebase.")
                
            } catch {
                print("Error updating voqa_catalogue: \(error.localizedDescription)")
            }
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
                            colors: QuizDataStruct.Colors(main: "", sub: "", third: ""),
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
        
        return quizCatalogueData
    }
    
    // Prepare the updated catalogue structure for upload
    func prepareUpdatedCatalogueForUpload(quizCatalogueData: [QuizCatalogueData]) -> [String: Any] {
        print("Preparing updated catalogue for upload...")
        
        let descriptions: [String: String] = [
            "Arts and Humanities": "Explore the rich history and diverse cultural expressions of humanity.",
            "Most Popular College Admission Exams": "Prepare for the most important college admission exams with our comprehensive quizzes.",
            "Most Popular Professional Certifications and Exams": "Enhance your career with top certifications and professional exams.",
            "Innovators' Hub (Tech and Innovation)": "Dive into the world of technology and innovation with these quizzes.",
            "Top Picks": "Our top selections of quizzes across various categories."
        ]
        
        var updatedCatalogue: [String: Any] = ["voqa_catalogue": [String: [String: Any]]()]
        
        // Cast the inner dictionary to [String: [String: Any]] before subscripting
        if var voqaCatalogue = updatedCatalogue["voqa_catalogue"] as? [String: [String: Any]] {
            for categoryData in quizCatalogueData {
                let quizzes = categoryData.quizzes.map { ["quizId": $0.id, "title": $0.quizTitle] }
                voqaCatalogue[categoryData.categoryName] = [
                    "descr": descriptions[categoryData.categoryName] ?? "No description available.",  // Add meaningful descriptions
                    "quizzes": quizzes
                ]
            }
            updatedCatalogue["voqa_catalogue"] = voqaCatalogue
        } else {
            print("Error: Could not cast `voqa_catalogue` to the expected type.")
        }
        
        print("Updated catalogue prepared: \(updatedCatalogue)")
        return updatedCatalogue
    }
    
    // Upload the updated catalogue to Firebase
    func uploadUpdatedCatalogueToFirebase(updatedCatalogue: [String: Any]) async throws {
        print("Starting to upload the updated catalogue to Firebase...")
        
        let catalogueRef = db.collection("voqa_catalogue").document("nNIARO0aAQV6S9MzZ2Fx")
        
        do {
            try await catalogueRef.setData(updatedCatalogue)
            print("Updated catalogue uploaded successfully to Firebase.")
        } catch {
            print("Error uploading updated catalogue: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Create and Assign Quizzes to the Catalogue
    func createAndAssignQuizzesToCatalogue(quizCollection: [QuizDataStruct]) async throws -> [QuizCatalogueData] {
        print("Starting to assign quizzes to the catalogue...")
        
        let assignments: [String: [String]] = [
            "Arts and Humanities": ["World War 1 History", "English Language Arts", "Advanced Placement Exam", "American History"],
            "Most Popular College Admission Exams": ["SAT", "MCAT (Medical College Admission Test)", "TOEFL (Test of English as a Foreign Language)", "Advanced Placement Exam", "General Chemistry"],
            "Most Popular Professional Certifications and Exams": ["MBE (Multistate Bar Examination)", "CPA (Certified Public Accountant)", "CYSA (Cybersecurity Analyst)", "Real Estate Licensing", "CompTIA A+"],
            "Innovators' Hub (Tech and Innovation)": ["Kotlin Programming Language", "CCNA (Cisco Certified Network Associate)", "CompTIA A+", "CYSA (Cybersecurity Analyst)", "Privacy Engineering Principles"],
            "Top Picks": ["SAT", "MCAT (Medical College Admission Test)", "CPA (Certified Public Accountant)", "CCNA (Cisco Certified Network Associate)", "CYSA (Cybersecurity Analyst)", "TOEFL (Test of English as a Foreign Language)", "World War 1 History", "MBE (Multistate Bar Examination)", "General Physics", "Advanced Placement Exam"]
        ]
        
        var quizCatalogueData = [QuizCatalogueData]()
        
        for (categoryName, quizTitles) in assignments {
            var quizzesInCategory: [QuizDataStruct] = []
            
            for quiz in quizCollection {
                if quizTitles.contains(quiz.quizTitle) {
                    quizzesInCategory.append(quiz)
                }
            }
            
            let categoryData = QuizCatalogueData(categoryName: categoryName, quizzes: quizzesInCategory)
            quizCatalogueData.append(categoryData)
        }
        
        // Print out the category names and quiz titles
        for category in quizCatalogueData {
            print("Category: \(category.categoryName)")
            for quiz in category.quizzes {
                print("  - Quiz: \(quiz.quizTitle)")
            }
        }
        
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
}
