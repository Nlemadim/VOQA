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
    
    func fetchVoqaDocument(documentId: String) async throws -> Voqa {
        let db = Firestore.firestore()
        print("Fetching document with ID: \(documentId)")
        
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("quizzes").document(documentId).getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let document = documentSnapshot, document.exists {
                    
                    print("Document found. Parsing data...")
                    if let data = document.data() {
//                        data.persistenceEnabled
                        print("Document data: \(data)")
                        
                        // Manually extracting data
                        let id = data["id"] as? String ?? ""
                        let quizTitle = data["quizTitle"] as? String ?? ""
                        let acronym = data["acronym"] as? String ?? ""
                        let about = data["about"] as? String ?? ""
                        let imageUrl = data["imageUrl"] as? String ?? ""
                        let rating = data["rating"] as? Int ?? 0
                        let curator = data["curator"] as? String ?? ""
                        let users = data["users"] as? Int ?? 0
                        let title = data["title"] as? String ?? ""
                        let titleImage = data["titleImage"] as? String ?? ""
                        
                        // Handling categories as a dictionary and converting to an array
                        let categoriesDict = data["categories"] as? [String: String] ?? [:]
                        let categories = Array(categoriesDict.values)
                        
                        // Handling colors
                        let colorsData = data["colors"] as? [String: String] ?? [:]
                        let colors = Colors(
                            main: colorsData["main"] ?? "",
                            sub: colorsData["sub"] ?? "",
                            third: colorsData["third"] ?? ""
                        )
                        
                        let ratings = data["ratings"] as? Int ?? 0
                        
                        // Initializing the Voqa model
                        let voqa = Voqa(
                            id: id,
                            quizTitle: quizTitle,
                            acronym: acronym,
                            about: about,
                            imageUrl: imageUrl,
                            rating: rating,
                            curator: curator,
                            users: users,
                            title: title,
                            titleImage: titleImage,
                            categories: categories,
                            colors: colors,
                            ratings: ratings
                        )
                        
                        print("Voqa object created successfully: \(voqa)")
                        continuation.resume(returning: voqa)
                    } else {
                        let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document data is nil"])
                        print("Document data is nil for ID: \(documentId)")
                        continuation.resume(throwing: notFoundError)
                    }
                } else {
                    let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                    print("Document not found with ID: \(documentId)")
                    continuation.resume(throwing: notFoundError)
                }
            }
        }
    }


    func createTestDocument() async throws {
        // 1. Set up Firestore
        let db = Firestore.firestore()

        // 2. Create a dictionary representing your document data
        let quizData: [String: Any] = [
            "id": "a2N1OYwYmku2Ei4vwIEz",
            "coreTopics": [
                "0": "Kotlin Fundamentals",
                "1": "Advanced Kotlin Programming",
                "2": "Object-Oriented Features and Collection Handling",
                "3": "Kotlin and Java Interplay",
                "4": "Learning Path",
                "5": "All Categories"
            ],
            "about": "Kotlin, developed by JetBrains, is a statically typed programming language designed to interoperate fully with Java and the Java Virtual Machine (JVM)...",
            "generalTopics": [
                "0": "Introduction to Kotlin",
                "1": "Setting up Kotlin Environment",
                "2": "Kotlin Syntax",
                "3": "Variables and Constants",
                "4": "Data Types",
                "5": "Comments and Documentation",
                "6": "Conditional Statements (if, when)",
                "7": "Loops (for, while, do-while)",
                "8": "Ranges in Kotlin",
                "9": "Defining Functions",
                "10": "Parameters and Return Types",
                "11": "Function Overloading",
                "12": "Lambdas and Higher-Order Functions",
                "13": "Inline Functions",
                "14": "Classes and Objects",
                "15": "Constructors",
                "16": "Properties and Fields",
                "17": "Methods",
                "18": "Inheritance",
                "19": "Interfaces",
                "20": "Abstract Classes",
                "21": "Lists, Sets, Maps",
                "22": "Mutable and Immutable Collections",
                "23": "Collection Operations (map, filter, reduce)",
                "24": "Iterating over Collections",
                "25": "Nullable and Non-Nullable Types",
                "26": "Safe Calls",
                "27": "Elvis Operator",
                "28": "Non-Null Assertions",
                "29": "Extension Functions",
                "30": "Extension Properties",
                "31": "Introduction to Coroutines",
                "32": "Launching Coroutines",
                "33": "Coroutine Scopes",
                "34.": "Suspending Functions",
                "35": "Channels",
                "36": "Standard Input and Output",
                "37": "String Manipulations",
                "38": "File Operations",
                "39": "Date and Time API",
                "40": "Working with JSON",
                "41": "Calling Java Code from Kotlin",
                "42": "Calling Kotlin Code from Java",
                "43": "Nullability in Java Interop",
                "44": "SAM Conversions",
                "45": "Generics",
                "46": "Type Aliases",
                "47": "Delegated Properties",
                "48": "Reflection",
                "49": "Annotations",
                "50": "DSL building"
            ],
            "quizTitle": "Kotlin Programming Language",
            "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/kotlin/Kotlin.png",
            "colors": [
                "main": "#1D8FCE",
                "sub": "#009688",
                "third": "#4CAF50"
            ],
            "curators": [],
            "ratings": 0,
            "users": 0,
            "accessToken": UUID().uuidString + "a2N1OYwYmku2Ei4vwIEz"
        ]
        
        do {
            // 3. Add the document to the "quizzes" collection
            try await db.collection("quizzes").document("a2N1OYwYmku2Ei4vwIEz").setData(quizData)
            print("Document added successfully!")
            
        } catch {
            print(error.localizedDescription)
            throw error
            
        }
    }
}

struct configUrls {
    static let homepageConfigUrl = "https://example.com/voqaCollection.json"
    static let getQuizCollection = "https://ljnsun.buildship.run/getQuizCollection"
}
