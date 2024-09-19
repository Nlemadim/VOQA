//
//  PageNavigationController.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    case createAccount
    case quizPlayer(Voqa)
    case mainView
    case homePage
    case quizDetailPage(Voqa)
    case quizDashboard(Voqa)
    // Add more cases as needed
}


class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    // Navigate to a specific destination
    func navigate(to destination: NavigationDestination) {
        path.append(destination)
        print("Calling navigation to: \(destination)")
    }
    
    // Go back by removing the last destination
    func goBack() {
        path.removeLast()
    }
    
    // Go back to root
    func resetNavigation() {
        path = NavigationPath()
    }
}



//struct PageNavigationController: Hashable {
//    enum NavigationType {
//        case quizInfo(Voqa)
//        case quizPlayerDetails(Voqa)
//        case createAccountView // New case for CreateAccountView
//        // Add more cases as needed for other views
//    }
//
//    let type: NavigationType
//
//    // Conformance to Hashable
//    func hash(into hasher: inout Hasher) {
//        switch type {
//        case .quizInfo(let voqa), .quizPlayerDetails(let voqa):
//            hasher.combine(voqa)
//        case .createAccountView:
//            hasher.combine("createAccount")
//        }
//    }
//
//    // Conformance to Equatable
//    static func == (lhs: PageNavigationController, rhs: PageNavigationController) -> Bool {
//        switch (lhs.type, rhs.type) {
//        case (.quizInfo(let lhsVoqa), .quizInfo(let rhsVoqa)):
//            return lhsVoqa == rhsVoqa
//        case (.quizPlayerDetails(let lhsVoqa), .quizPlayerDetails(let rhsVoqa)):
//            return lhsVoqa == rhsVoqa
//        case (.createAccountView, .createAccountView):
//            return true
//        default:
//            return false
//        }
//    }
//}


//struct PageNavigationController: Hashable {
//    enum NavigationType {
//        case quizInfo(Voqa)
//        case quizPlayerDetails(Voqa)
//        case quizPlayerView
//        // Add more cases as needed for other views
//    }
//
//    let type: NavigationType
//
//    // Conformance to Hashable
//    func hash(into hasher: inout Hasher) {
//        switch type {
//        case .quizInfo(let voqa), .quizPlayerDetails(let voqa):
//            hasher.combine(voqa)
//        case .quizPlayerView:
//            hasher.combine("createAccount")
//        }
//    }
//
//    // Conformance to Equatable
//    static func == (lhs: PageNavigationController, rhs: PageNavigationController) -> Bool {
//        switch (lhs.type, rhs.type) {
//        case (.quizInfo(let lhsVoqa), .quizInfo(let rhsVoqa)):
//            return lhsVoqa == rhsVoqa
//        case (.quizPlayerDetails(let lhsVoqa), .quizPlayerDetails(let rhsVoqa)):
//            return lhsVoqa == rhsVoqa
//        case (.quizPlayerView, .quizPlayerView):
//            return true
//        default:
//            return false
//        }
//    }
//}
