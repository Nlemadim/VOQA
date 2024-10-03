//
//  DatabaseManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import Combine

@MainActor
class DatabaseManager: ObservableObject {
    @Published var currentError: DatabaseError?
    @Published var questions: [Question] = []
    @Published var sessionConfiguration: QuizSessionConfig?
    @Published var quizCatalogue: [QuizCatalogue] = []  // Holds the QuizCatalogue
    @Published var quizCollection: [QuizData] = []
    @Published var showFullPageError: Bool = false
    
    //added
    @Published var fetchingSessionIntro: Bool = false
    
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
    
    //MARK: Load Vopice Config:- Local Voice Config Data
    func loadVoiceConfiguration(for voice: AddOnItem) async throws {
        let loadedConfig = try await configManager.loadVoiceConfiguration(for: voice)
        self.sessionConfiguration = loadedConfig
    }
    
    func fetchProcessedQuestions(config: UserConfig, quizTitle: String, prompt: String?, maxNumberOfQuestions: Int) async throws {
        // Initialize the QuestionDownloader with the UserConfig from the environment
        let questionDownloader = QuestionDownloader(config: config)
        
        // Fetch the questions from the live API
        let newQuestions = try await questionDownloader.downloadQuizQuestions(
            userId: config.userId,
            quizTitle: quizTitle,
            narratorId: self.sessionConfiguration?.sessionVoiceId ?? "UNKNOWN", // Ensure voice ID is available
            numberOfQuestions: 3
        )
        
        // Check if session configuration is available
        if let sessionConfig = self.sessionConfiguration {
            print("Session ID: \(sessionConfig.sessionId)")
            print("Quiz Title: \(quizTitle)")
            
            // Ensure quizHostMessages is available and safely unwrap
            if let quizHostMessages = sessionConfig.quizHostMessages {
                // Fetch the session intro using the network service
                let sessionIntro = try await networkService.fetchCurrentSessionIntro(
                    userId: config.userId,
                    quizTitle: sessionConfig.sessionTitle,
                    narrator: sessionConfig.sessionVoiceId ?? "UNKNOWN", // Ensure a valid voice ID is passed
                    questionIds: newQuestions.map { $0.id }
                )
                
                quizHostMessages.quizSessionIntro.audioUrls = sessionIntro.audioUrls
                
                if quizHostMessages.quizSessionIntro.title.isEmptyOrWhiteSpace {
                    quizHostMessages.quizSessionIntro.title = "dynamicSessionIntro"
                }
                
                // Assign the fetched session intro to the quizSessionIntro in quizHostMessages
                quizHostMessages.quizSessionIntro = sessionIntro
                
                // Update the session config's host messages
                sessionConfig.quizHostMessages = quizHostMessages
                
                // Append the new questions to the session configuration
                sessionConfig.sessionQuestion.append(contentsOf: newQuestions)
                
                print("\(newQuestions.count) question(s) fetched")
                print("Session config now contains \(sessionConfig.sessionQuestion.count) questions")
                
                // Debugging: Print each question's details
                for (index, question) in newQuestions.enumerated() {
                    print("Question \(index + 1): ID = \(question.id), Content = \(question.content)")
                }
            } else {
                print("quizHostMessages is nil.")
            }
        } else {
            print("sessionConfiguration is nil.")
        }
    }

    
    //MARK: Fetch Quiz Collection from Firebase
    func fetchQuizCollection() async {
        do {
            let collection = try await firebaseManager.fetchQuizCollection()
            self.quizCollection = collection
            // After fetching, create the catalogue
            self.quizCatalogue = self.createQuizCatalogue(from: collection)
        } catch {
            print("Error fetching quiz collection: \(error.localizedDescription)")
        }
    }
    
    
    func addUserToChannel(userId: String) {
        /**
         {
         "userId":"",
         "username":"",
         "quizTitle":"",
         "joinDate":""
         }
         */
    }
    
    func buildQuestionsCache(voqa: Voqa) {
        /**
         Request Body
         {
         "userId":"rBkUyTtc2XXXcj43u53N",
         "quizTitle":"MCAT",
         "questionStyle":"ALL Categories",
         "numberOfQuestions":"5"
         }
         
         */
    }
    
    // Create Quiz Catalogue Locally
    func createQuizCatalogue(from quizCollection: [QuizData]) -> [QuizCatalogue] {
        let assignments: [CatalogueDetails: [QuizList]] = [
            .technologyAndInnovation(): [
                .amazonWebServices, .kotlinProgramming, .swiftProgramming,
                .microsoftAzure, .privacyEngineeringPrinciples, .ethicalHackingPrinciples,
                .objectOrientedProgramming, .linux, .dataPrivacy
            ],
            .healthAndMedical(): [
                .medicalCollegeAdmissionTest, .nclexRN, .generalBiology,
                .humanAnatomy, .generalChemistry
            ],
            .historyAndGovernment(): [
                .usConstitution, .americanHistory, .historyOfWorldWar1, .historyOfWorldWar2
            ],
            .businessAndFinance(): [
                .realEstateLicensing, .certifiedPublicAccountantExam, .multistateBarExamination
            ],
            .sportsAndRecreation(): [
                .mlbGreatestOfAllTime, .nbaGreatestOfAllTime, .worldCupHistory,
                .f1RacingGreatestOfAllTime, .nascarGreatestOfAllTime
            ],
            .certificationsAndExams(): [
                .ciscoCertifiedNetworkAssociateExam, .comptiaCYSAPlus,
                .iappCertification, .comptiaAPlus
            ],
            .educationAndTesting(): [
                .act, .testOfEnglishAsForeignLanguage, .sat, .gre,
                .lawSchoolAdmissionTest, .advancedPlacementExam, .engineerInTraining
            ],
            .topPicks(): [
                .sat, .amazonWebServices, .advancedPlacementExam, .comptiaAPlus,
                .generalBiology, .swiftProgramming
            ]
        ]
        
        var quizCatalogue = [QuizCatalogue]()
        
        for (category, quizEnums) in assignments {
            var quizzesInCategory: [Voqa] = []
            
            for quizEnum in quizEnums {
                if let quiz = quizCollection.first(where: { $0.quizTitle == quizEnum.rawValue }) {
                    //print("Mapped Quiz: \(quiz.quizTitle) -> \(quizEnum.rawValue) in \(category.details.title)")
                    quizzesInCategory.append(Voqa(from: quiz))
                } else {
                    print("No match found for \(quizEnum.rawValue) in \(category.details.title)")
                    // Optionally log possible matches based on lowercased quiz titles for debugging
                    let possibleMatches = quizCollection.filter { $0.quizTitle.lowercased() == quizEnum.rawValue.lowercased() }
                    if !possibleMatches.isEmpty {
                        //print("Possible matches found for \(quizEnum.rawValue): \(possibleMatches.map { $0.quizTitle })")
                    }
                }
            }
            
            // Create and append the QuizCatalogue for each category
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

extension NetworkService {
    
    // Async method version
    func fetchCurrentSessionIntro(userId: String, quizTitle: String, narrator: String, questionIds: [String]) async throws -> VoicedFeedback {
        print("Networkk Service fetching Quiz Session Info")
        // Create the request body
        let requestBody: [String: Any] = [
            "userId": userId,
            "quizTitle": quizTitle,
            "narrator": narrator,
            "questionIds": questionIds
        ]
        
        // Ensure the URL is valid
        guard let url = URL(string: ConfigurationUrls.dynamicSessioninfo) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert the request body to JSON
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        // Perform the async network call using URLSession
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the response into VoicedFeedback
        let feedback = try JSONDecoder().decode(VoicedFeedback.self, from: data)
        
        return feedback
    }
}


