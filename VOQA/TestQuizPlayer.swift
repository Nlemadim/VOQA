//
//  TestQuizPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/24/24.
//

import Foundation
import SwiftUI
import Combine

final class TestQuizPlayer {
    @StateObject private var user = User()
    @StateObject private var databaseManager = DatabaseManager.shared
    @StateObject private var viewModel: QuizViewModel
    private var quizConfigManager: QuizConfigManager
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.quizConfigManager = QuizConfigManager()
        let quizSessionManager = QuizSessionManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: self.quizConfigManager))
    }
    
    func configureNewSession() {
        if let config = databaseManager.sessionConfiguration {
            let updatedConfig = config
            viewModel.initializeSession(with: updatedConfig)
            viewModel.startQuiz()
        } else {
            print("failed to load config")
        }
    }

    func loadQuizPlayerView(completion: @escaping (QuizPlayerView?) -> Void) {
        Task {
            await loadUserVoiceSelection()

            let mockVoqaItem = MockVoqaItem(
                quizTitle: "World War II History",
                acronym: "WWII",
                about: "Study the pivotal events, key figures, and global impact of World War II through this engaging quiz.",
                imageUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/WorldWar2/ww_2.png",
                colors: ThemeColors(main: "#f7e3a9", sub: "#dec388", third: "#f2e9c1")
            )

            // Load questions using the QuestionLoader
            let questionLoader = QuestionDownloader(config: user.userConfig)
            let questions = questionLoader.loadMockQuestions()
            

            DispatchQueue.main.async {
                if let config = self.databaseManager.sessionConfiguration {
                    config.sessionQuestion = questions
                    
                    let quizPlayerView = QuizPlayerView(config: config, voqaItem: mockVoqaItem)
                    completion(quizPlayerView)
                }
            }
        }
    }
    

    private func loadUserVoiceSelection() async {
        let defaultVoiceItems = AddOnItem.defaultNarratorItems
        let selectedVoiceNarrator = user.userConfig.selectedVoiceNarrator

        // Safely unwrap userConfig.selectedVoiceNarrator
        guard !selectedVoiceNarrator.isEmptyOrWhiteSpace else {
            print("No selected voice narrator found")
            return
        }

        // Proceed with voice selection logic
        if let currentItem = defaultVoiceItems.first(where: { $0.name == selectedVoiceNarrator }) {
            do {
                try await databaseManager.loadVoiceConfiguration(for: currentItem)
            } catch {
                print("Error loading default voice selection: \(error.localizedDescription)")
            }
        } else {
            print("No matching voice found in defaultVoiceItems")
        }
    }
}

#Preview {
    TestQuizPlayerPreview()
        .preferredColorScheme(.dark)
}

struct TestQuizPlayerPreview: View {
    @State private var quizPlayerView: QuizPlayerView?
    private let testQuizPlayer = TestQuizPlayer()  // Single instance of TestQuizPlayer

    var body: some View {
        Group {
            if let quizPlayerView = quizPlayerView {
                quizPlayerView
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            // Call configureNewSession and loadQuizPlayerView in sequence
            testQuizPlayer.configureNewSession()
            
            
            testQuizPlayer.loadQuizPlayerView { view in
                self.quizPlayerView = view
            }
        }
    }
}


struct MockVoqaItem: VoqaItem {
    var quizTitle: String
    var acronym: String
    var about: String
    var imageUrl: String
    var colors: ThemeColors
}

let previewVoqaItem = MockVoqaItem(
    quizTitle: "World War II History",
    acronym: "WWII",
    about: "Study the pivotal events, key figures, and global impact of World War II through this engaging quiz.",
    imageUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/WorldWar2/WorldWar2.png",
    colors: ThemeColors(main: "#8E44AD", sub: "#9B59B6", third: "#34495E")
)

