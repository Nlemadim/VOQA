//
//  Performance.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/16/24.
//

import Foundation

struct Performance: Identifiable, Hashable {
    let id: UUID
    var quizTitle: String
    var date: Date
    var score: CGFloat
    var numberOfQuestions: Int
    
    init(id: UUID, quizTitle: String, date: Date, score: CGFloat, numberOfQuestions: Int) {
        self.id = id
        self.quizTitle = quizTitle
        self.date = date
        self.score = score
        self.numberOfQuestions = numberOfQuestions
    }
}
