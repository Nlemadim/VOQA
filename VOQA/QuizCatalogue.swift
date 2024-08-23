//
//  QuizCatalogue.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/22/24.
//

import Foundation

struct QuizCatalogue: Identifiable, Hashable {
    var id: UUID = UUID() // Automatically generated UUID for each instance
    var categoryName: String
    var description: String
    var quizzes: [Voqa]
    
    // Initializer from QuizCatalogueData
    init(from quizCatalogueData: QuizCatalogueData) {
        self.categoryName = quizCatalogueData.categoryName
        self.quizzes = quizCatalogueData.quizzes.map { Voqa(from: $0) }
        self.description = "" // Assuming a default empty description if not provided
    }
    
    // Initializer with categoryName, description, and quizzes
    init(categoryName: String, description: String, quizzes: [Voqa]) {
        self.categoryName = categoryName
        self.quizzes = quizzes
        self.description = description
    }
    
    // Conformance to Hashable and Identifiable
    static func == (lhs: QuizCatalogue, rhs: QuizCatalogue) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

