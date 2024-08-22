//
//  DatabaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import Combine

class DatabaseManager: ObservableObject {
    @Published var currentError: DatabaseError?
    @Published var questions: [Question] = []
    @Published var quizCatalogue: [QuizCatalogueData] = []
    @Published var quizCollection: [QuizDataStruct] = []
    @Published var showFullPageError: Bool = false
    
    static let shared = DatabaseManager()
    
    private let firebaseManager = FirebaseManager.shared
    private var networkService = NetworkService()
    private init() {}
    
    func handleError(_ error: DatabaseError) {
        self.currentError = error
        if let errorType = error.errorType {
            switch errorType {
            case .databaseError(let dbError):
                switch dbError {
                case .downloadError, .saveError:
                    self.showFullPageError = false
                case .accessError:
                    self.showFullPageError = true
                }
            case .connectionError:
                // Handle connection errors if necessary
                break
                
            default:
                break
            }
        }
    }
    
    func fetchQuestions() async {
        print("Database fetching Questions")
        do {
            let downloadedQuestions = try await networkService.fetchQuestions()
            //networkService.printQuestionUrls(questions: questions)
            DispatchQueue.main.async {
                self.questions = downloadedQuestions
            }
            print("Questions fetched successfully: \(questions.count) questions.")
        } catch {
            print("Error fetching questions: \(error)")
        }
    }
    
    func fetchQuizCatalogue() async {
        do {
            let catalogue = try await firebaseManager.fetchQuizCatalogue()
            DispatchQueue.main.async {
                self.quizCatalogue = catalogue
            }
        } catch {
            print("Error fetching quiz catalogue: \(error)")
        }
    }
    
    func fetchQuizCollection() async {
        do {
            let collection = try await firebaseManager.fetchQuizCollection()
            DispatchQueue.main.async {
                self.quizCollection = collection
            }
        } catch {
            print("Error fetching quiz collection: \(error.localizedDescription)")
        }
    }
    
    func uploadQuiz(quiz: QuizDataStruct) async {
        do {
            try await firebaseManager.uploadQuizDocumentToFirebase(quiz: quiz)
        } catch {
            print("Error uploading quiz: \(error)")
        }
    }
}
