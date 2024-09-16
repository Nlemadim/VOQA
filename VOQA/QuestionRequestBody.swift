//
//  QuestionRequestBody.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

struct QuestionRequestBody: Codable {
    var userId: String
    var quizTitle: String
    var request: String
    var narrator: String
    var numberOfQuestions: Int
}
