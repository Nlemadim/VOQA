//
//  DynamicContentManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/2/24.
//

import Foundation
import SwiftUI

protocol SessionConfigurable {
    func fetchCurrentSessionIntro() async throws
}

class DynamicContentManager {
    private var networkService = NetworkService()
    
    @Published var isSessionIntroFetched: Bool = false
    var session: QuizSession?
    
}


//extension DatabaseManager: SessionConfigurable {}
