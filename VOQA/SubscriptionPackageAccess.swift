//
//  SubscriptionPackageAccess.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation

// Enum for Subscription Package Access
enum SubscriptionPackageAccess: String {
    case fullQuizCollection
    case quizBuilderAccess
    case questionContributionAccess
    case fullQuizSession
    case guestQuizSession
    case contributionRewards
    
    var description: String {
        switch self {
        case .fullQuizCollection:
            return "Access to the complete quiz collection."
        case .quizBuilderAccess:
            return "Ability to create and customize quizzes."
        case .questionContributionAccess:
            return "Contribute and suggest new quiz questions."
        case .fullQuizSession:
            return "Access to full-length quiz sessions."
        case .guestQuizSession:
            return "Limited access to guest quiz sessions."
        case .contributionRewards:
            return "Earn rewards for contributing content."
        }
    }
}
