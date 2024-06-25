//
//  TopicCategories.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

enum TopicCategory: Int, Codable, Identifiable, CaseIterable {
    case foundational = 1, beginner, intermediate, advanced
    
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .foundational:
            return "Foundational"
        case .beginner:
            return "Beginner"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        }
    }
}
