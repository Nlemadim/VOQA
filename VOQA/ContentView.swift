//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        PrototypeMainView()
            .task {
                await getQuizConfiguration()
            }
        //QuizContextModuleTest()
        //BaseMainView()
    }
    
    func getQuizConfiguration() async {
        let configManager = QuizConfigManager()
        
        do {
            let config = try await configManager.downloadConfiguration()
            configManager.printUrls(for: config.controlFeedback)
            configManager.printUrls(for: config.quizFeedback)
        } catch {
            print("Failed to download configuration: \(error)")
        }
        
        // You can now use the downloaded configuration
    }
    
    
//    func fetchFeedbackConfig() async {
//        let configManager = ConfigurationManager()
//        
//        var controlFeedback = configManager.createControlFeedbackModels()
//        var quizFeedback = configManager.createQuizFeedbackModels()
//        
//        do {
//            controlFeedback.startQuiz = try await configManager.populateAudioUrls(for: controlFeedback.startQuiz)
//            controlFeedback.quit = try await configManager.populateAudioUrls(for: controlFeedback.quit)
//            controlFeedback.nextQuestion = try await configManager.populateAudioUrls(for: controlFeedback.nextQuestion)
//            controlFeedback.repeatQuestioon = try await configManager.populateAudioUrls(for: controlFeedback.repeatQuestioon)
//            
//            configManager.printUrls(for: controlFeedback)
//            
//            quizFeedback.incorrectAnswer = try await configManager.populateAudioUrls(for: quizFeedback.incorrectAnswer)
//            quizFeedback.correctAnswer = try await configManager.populateAudioUrls(for: quizFeedback.correctAnswer)
//            quizFeedback.noResponse = try await configManager.populateAudioUrls(for: quizFeedback.noResponse)
//            
//            configManager.printUrls(for: quizFeedback)
//        } catch {
//            print("Failed to populate audio URLs: \(error)")
//        }
//    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
