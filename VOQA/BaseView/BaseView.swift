//
//  BaseView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI
import SwiftData

struct BaseView<Content: View>: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var databaseManager = DatabaseManager.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @State private var config: QuizSessionConfig?
    
    let content: () -> Content

    var body: some View {
        content()
            .environment(\.quizSessionConfig, config)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await setupQuizSessionConfig()
                }
            }
            .alert(item: $databaseManager.currentError) { error in
                Alert(
                    title: Text(error.title ?? "Error"),
                    message: Text(error.message ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
//            .alert(item: $networkMonitor.connectionError) { error in
//                Alert(
//                    title: Text(error.title ?? "Network Error"),
//                    message: Text(error.message ?? "An unknown network error occurred."),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
            .overlay(
                databaseManager.showFullPageError ? fullPageErrorView : nil
            )
    }

    private func setupQuizSessionConfig() async {
        let configManager = QuizConfigManager()

        do {
            let localConfig = try configManager.loadLocalConfiguration()
            self.config = localConfig
            
            print("Local configuration loaded successfully")
        } catch {
            print("Failed to load local configuration: \(error)")
            do {
                let downloadedConfig = try await configManager.downloadConfiguration()
                self.config = downloadedConfig
                
                print("Downloaded configuration loaded successfully")
            } catch {
                print("Failed to download configuration: \(error)")
            }
        }
    }

    
    var fullPageErrorView: some View {
        VStack {
            Text(databaseManager.currentError?.title ?? "Error")
                .font(.largeTitle)
                .padding()
            Text(databaseManager.currentError?.message ?? "An unknown error occurred.")
                .padding()
            Button(action: {
                // Handle retry logic here
                databaseManager.showFullPageError = false
            }) {
                Text("Retry")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}


struct QuizSessionConfigKey: EnvironmentKey {
    static let defaultValue: QuizSessionConfig? = nil
}

extension EnvironmentValues {
    var quizSessionConfig: QuizSessionConfig? {
        get { self[QuizSessionConfigKey.self] }
        set { self[QuizSessionConfigKey.self] = newValue }
    }
}

