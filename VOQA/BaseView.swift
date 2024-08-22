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

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if logStatus {
                    if !databaseManager.quizCatalogue.isEmpty {
                        Text("Catalogue ready!")
        
                       // Pass the created catalogue to HomePage
                       // HomePage(quizCatalogue: databaseManager.quizCatalogue)
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
                    await databaseManager.fetchQuizCollection()
                }
                if !databaseManager.quizCatalogue.isEmpty {
                    print("Catalogue downloaded")
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

    var fullPageErrorView: some View {
        VStack {
            Text(databaseManager.currentError?.title ?? "Error")
                .font(.largeTitle)
                .padding()
            Text(databaseManager.currentError?.message ?? "An unknown error occurred.")
                .padding()
            Button(action: {
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
