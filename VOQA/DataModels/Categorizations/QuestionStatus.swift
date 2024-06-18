//
//  QuestionStatus.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation

enum QuestionStatus: Int, Codable, Identifiable, CaseIterable {
    case newQuestion, repeatQuestion, modifiedQuestion
    var id: Self {
        self
    }
    
    var descr: String {
        
        switch self {
        case .newQuestion:
            "New Question"
        case .repeatQuestion:
            "Repeat Question"
        case .modifiedQuestion:
            "Modified Question"
        }
    }
}
