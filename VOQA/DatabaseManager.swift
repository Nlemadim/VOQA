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
    @Published var quizCatalogue: [QuizCatalogue] = []  // Holds the QuizCatalogue
    @Published var quizCollection: [QuizData] = []
    @Published var showFullPageError: Bool = false
    
    @Published var ratingsAndReview: RatingsAndReview?
    @Published var latestScores: LatestScore?
    @Published var contributedQuestion: [ContributeAQuestion] = []
    @Published var performanceHistory: [Performance] = []
    
    @Published var userHighScore: Int = 0
    @Published var totalQuestionsAnswered: Int = 0
    @Published var quizzesCompleted: Int = 0
    
    static let shared = DatabaseManager()
    
    private let firebaseManager = FirebaseManager.shared
    private var networkService = NetworkService()
    private var configManager = QuizConfigManager()
    var sessionConfiguration: QuizSessionConfig?
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
                break
            default:
                break
            }
        }
    }
    
    
    func loadVoiceConfiguration(for voice: AddOnItem) async throws  {
        let loadedConfig = try await configManager.loadVoiceConfiguration(for: voice)
        self.sessionConfiguration = loadedConfig
    }
    
    func fetchQuestions() async {
        print("Database fetching Questions")
        do {
            let downloadedQuestions = try await networkService.fetchQuestions()
            DispatchQueue.main.async {
                self.questions = downloadedQuestions
            }
            print("Questions fetched successfully: \(questions.count) questions.")
        } catch {
            print("Error fetching questions: \(error)")
        }
    }
    
    
    func fetchQuizCollection() async {
        do {
            let collection = try await firebaseManager.fetchQuizCollection()
            DispatchQueue.main.async {
                self.quizCollection = collection
                for quiz in collection {
                    print("Quiz Title: \(quiz.quizTitle)")
                }
                
                // After fetching, create the catalogue
                self.quizCatalogue = self.createQuizCatalogue(from: collection)
            }
        } catch {
            print("Error fetching quiz collection: \(error.localizedDescription)")
        }
    }
    
    // Create Quiz Catalogue Locally
    func createQuizCatalogue(from quizCollection: [QuizData]) -> [QuizCatalogue] {
        let assignments: [CatalogueDetails: [QuizList]] = [
            .artsAndHumanities(): [.historyOfWorldWar1, .englishLanguageArts, .advancedPlacementExam, .americanHistory],
            .collegeAdmissionsExams(): [.sat, .medicalCollegeAdmissionTest, .testOfEnglishAsForeignLanguage, .advancedPlacementExam, .generalChemistry],
            .professionalCertifications(): [.multistateBarExamination, .certifiedPublicAccountantExam, .comptiaCYSAPlus, .realEstateLicensing, .comptiaAPlus],
            .techAndInnovation(): [.kotlinProgramming, .ciscoCertifiedNetworkAssociateExam, .comptiaAPlus, .privacyEngineeringPrinciples],
            .topPicks(): [.sat, .medicalCollegeAdmissionTest, .certifiedPublicAccountantExam, .ciscoCertifiedNetworkAssociateExam, .comptiaCYSAPlus, .testOfEnglishAsForeignLanguage, .historyOfWorldWar1, .multistateBarExamination, .generalPhysics, .advancedPlacementExam]
        ]

        var quizCatalogue = [QuizCatalogue]()
        
        for (category, quizEnums) in assignments {
            var quizzesInCategory: [Voqa] = []
            
            for quizEnum in quizEnums {
                if let quiz = quizCollection.first(where: { $0.quizTitle == quizEnum.rawValue }) {
                    quizzesInCategory.append(Voqa(from: quiz))
                }
            }
            
            let categoryData = QuizCatalogue(
                categoryName: category.details.title,
                description: category.details.description,
                quizzes: quizzesInCategory
            )
            quizCatalogue.append(categoryData)
        }
        
        return quizCatalogue
    }
    
    func createUserProfile(for user: User) async throws {
        let userProfile = user.createUserProfile()
        try await networkService.postUserProfile(userProfile)
    }
    
    func uploadQuiz(quiz: QuizData) async {
        do {
            try await firebaseManager.uploadQuizDocumentToFirebase(quiz: quiz)
        } catch {
            print("Error uploading quiz: \(error)")
        }
    }
    
    func postNewQuestion(_ newQuestion: ContributeAQuestion) {
        let questionToPost = newQuestion.questionText
        print("Posting Question")
        print(questionToPost)
        //Set up validation and question post configuration
        //networkService.postQuestion(userId: String, quizId: String, questionText: String)
    }
    
    func postNewReview(_ review: RatingsAndReview) {
        let  reviewToPost = review
        print("Posting Review")
        print(reviewToPost.difficultyRating as Any)
        print(reviewToPost.narrationRating as Any)
        print(reviewToPost.relevanceRating as Any)
        print(reviewToPost.comment as Any)
        //Set up validation and question post configuration
        //networkService.postReview(userId: String, quizId: String, diificultyRating: Int, relevanceRating: Int, narratorRating: Int, comment: Int? = nil)
    }
}
