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
    case quizPlayer(config: QuizSessionConfig, voqa: Voqa)
    case mainView
    case homePage
    case quizDetailPage(Voqa)
    case quizDashboard(Voqa)
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



