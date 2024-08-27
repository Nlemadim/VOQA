//
//  AccountType.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/27/24.
//

import Foundation
// Enum for Account Type
enum AccountType: String {
    case guest = "Guest"
    case premium = "Premium"
    case beta = "BETA"
    
    var packageAccess: [SubscriptionPackageAccess] {
        switch self {
        case .guest:
            return [.guestQuizSession, .fullQuizCollection]
        case .premium, .beta:
            return [.fullQuizCollection, .quizBuilderAccess, .questionContributionAccess, .fullQuizSession, .contributionRewards]
        }
    }
}
