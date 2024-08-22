//
//  QuizCatalogue.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/22/24.
//

import Foundation

struct QuizCatalogue {
    var categoryName: String
    var quizzes: [Voqa]
    
    // Initializer from QuizCatalogueData
    init(from quizCatalogueData: QuizCatalogueData) {
        self.categoryName = quizCatalogueData.categoryName
        self.quizzes = quizCatalogueData.quizzes.map { Voqa(from: $0) }
    }
    
    // Initializer with categoryName and quizzes
    init(categoryName: String, quizzes: [Voqa]) {
        self.categoryName = categoryName
        self.quizzes = quizzes
    }
}
