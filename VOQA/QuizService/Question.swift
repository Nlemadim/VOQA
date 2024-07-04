//
//  Question.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/4/24.
//

import Foundation

struct Question {
    var id: UUID
    var topicId: UUID
    var content: String
    var options: [String]
    var correctOption: String
    var selectedOption: String = ""
    var isAnswered: Bool = false
    var isAnsweredCorrectly: Bool
    var numberOfPresentations: Int
    var audioScript: String
    var audioUrl: String
}
