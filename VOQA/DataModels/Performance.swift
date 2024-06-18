//
//  Performance.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftData

@Model
class Performance: Identifiable, Hashable {
    let id: UUID
    var quizName: String
    var date: Date
    var score: CGFloat
    var numberOfQuestions: Int
    
    init(id: UUID, quizName: String, date: Date, score: CGFloat, numberOfQuestions: Int) {
        self.id = id
        self.quizName = quizName
        self.date = date
        self.score = score
        self.numberOfQuestions = numberOfQuestions
    }
}
