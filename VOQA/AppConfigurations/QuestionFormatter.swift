//
//  QuestionFormatter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/13/24.
//

import Foundation

struct QuestionFormatter {
    static func formatQuestion(question: Question) -> String {
        var formattedQuestion = 
        
        """
        New Question

        \(question.content)

        Options:
        
        Option \(question.options[0])
        
        Option \(question.options[1])
        
        Option \(question.options[2])
        
        Option \(question.options[3])
        
        """

        // Remove or replace disallowed characters
        formattedQuestion = formattedQuestion.replacingOccurrences(of: "\n", with: " ")
        formattedQuestion = formattedQuestion.replacingOccurrences(of: "\r", with: " ")
        formattedQuestion = formattedQuestion.replacingOccurrences(of: "\"", with: "'")

        return formattedQuestion
    }
    
    static func formatQuestionText(question: Question) -> String {
        var formattedQuestion =
        
        """
        New Question!\n
        \(question.content)\n

        Options:\n
        \(question.options[0])\n
        \(question.options[1])\n
        \(question.options[2])\n
        \(question.options[3])\n
        
        """

        return formattedQuestion
    }


}
