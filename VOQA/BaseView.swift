//
//  BaseView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

struct BaseView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var path = NavigationPath()
    @State private var config: QuizSessionConfig?
    @State var logStatus: Bool
    var configManager = QuizConfigManager()

    // New state variable to hold the converted quiz catalogue
    @State private var quizCatalogue: [QuizCatalogue] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if logStatus {
                    if !quizCatalogue.isEmpty {
                       // HomePage(quizCatalogue: quizCatalogue)
                    } else {
                        Text("Loading quizzes...")
                    }
                } else {
                    Text("App Sign In placeHolder")
                }
            }
            .environment(\.quizSessionConfig, config)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await setupQuizSessionConfig()
                    await loadQuizData()
                }
            }
            .alert(item: $databaseManager.currentError) { error in
                Alert(
                    title: Text(error.title ?? "Error"),
                    message: Text(error.message ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(item: $networkMonitor.connectionError) { error in
                Alert(
                    title: Text(error.title ?? "Network Error"),
                    message: Text(error.message ?? "An unknown network error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay(
                databaseManager.showFullPageError ? fullPageErrorView : nil
            )
        }
    }

    private func setupQuizSessionConfig() async {
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

    private func loadQuizData() async {
       Task {
            await databaseManager.fetchQuizCatalogue()
            await databaseManager.fetchQuizCollection()
            
            // Convert fetched QuizCatalogueData to QuizCatalogue
            let convertedCatalogue = databaseManager.quizCatalogue.map { QuizCatalogue(from: $0) }
            DispatchQueue.main.async {
                self.quizCatalogue = convertedCatalogue
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


