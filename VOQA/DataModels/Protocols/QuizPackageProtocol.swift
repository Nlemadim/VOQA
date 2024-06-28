//
//  QuizPackageProtocol.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

//import Foundation
//
//protocol QuizPackage {
//    var title: String { get }
//    var titleImage: String { get }
//    var topics: [Topic] { get }
//    var audioQuiz: AudioQuiz? { get }
//}
//
//protocol QuizPackageProtocol: Decodable, Identifiable {
//    var id: UUID { get }
//    var title: String { get }
//    var titleImage: String { get }
//    var summaryDesc: String { get }
//    var themeColors: [Int] { get }
//    var rating: Int? { get }
//    var numberOfRatings: Int? { get }
//    var edition: PackageEdition { get }
//    var curator: String? { get }
//    var users: Int? { get }
//    var category: [QuizCategories] { get }
//}
//
//protocol AudioQuizProtocol: Decodable, Identifiable {
//    var id: UUID { get }
//    var quizTitle: String { get }
//    var titleImage: String { get }
//    var shortTitle: String { get }
//    var firstStarted: Date { get }
//    var completions: Int { get }
//    var userHighScore: Int { get }
//    var ratings: Int { get }
//    var currentQuizTopicIDs: [String] { get }
//    var topics: [Topic] { get }
//}
//
//
////enum QuizPackageType: Identifiable {
////    case standard(StandardQuizPackage)
////    case custom(CustomQuizPackage)
////    
////    var id: UUID {
////        switch self {
////        case .standard(let package):
////            return package.id
////        case .custom(let package):
////            return package.id
////        }
////    }
////    
////    var wrapped: any QuizPackageProtocol {
////        switch self {
////        case .standard(let package):
////            return package
////        case .custom(let package):
////            return package
////        }
////    }
////}
//
