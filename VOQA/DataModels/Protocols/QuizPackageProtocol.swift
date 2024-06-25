//
//  QuizPackageProtocol.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation

protocol QuizPackage {
    var title: String { get }
    var titleImage: String { get }
    var topics: [Topic] { get }
    var audioQuiz: AudioQuiz? { get }
}

protocol QuizPackageProtocol: Decodable {
    var id: UUID { get }
    var title: String { get }
    var titleImage: String { get }
    var summaryDesc: String { get }
    var themeColors: [Int] { get }
    var rating: Int? { get }
    var numberOfRatings: Int? { get }
    var edition: PackageEdition { get }
    var curator: String? { get }
    var users: Int? { get }
}

protocol AudioQuizProtocol: Decodable {
    var id: UUID { get }
    var quizTitle: String { get }
    var titleImage: String { get }
    var shortTitle: String { get }
    var firstStarted: Date { get }
    var completions: Int { get }
    var userHighScore: Int { get }
    var ratings: Int { get }
    var currentQuizTopicIDs: [String] { get }
    var topics: [Topic]? { get }
}

