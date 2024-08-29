//
//  MainView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var user: User
    @State private var path = NavigationPath()
    @State private var config: QuizSessionConfig?
    @State var logStatus: Bool
    var configManager = QuizConfigManager()
    
    var body: some View {
        VStack {
            if !databaseManager.quizCatalogue.isEmpty {
                HomePage(quizCatalogue: databaseManager.quizCatalogue)
            } else {
                VStack(alignment: .center) {
                    CustomSpinnerView()
                        .frame(height: 45)
                }
            }
        }
        .environment(\.quizSessionConfig, config)
        .preferredColorScheme(.dark)
        .onAppear {
            Task {
                //await setupQuizSessionConfig()
                await loadUserVoiceSelection()
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
    
    private func loadUserVoiceSelection() async {
        let defaultVoiceItems = AddOnItem.defaultNarratorItems
        if let currentItem = defaultVoiceItems.first(where: { $0.name == user.userConfig.selectedVoiceNarrator }) {
            do {
                try await databaseManager.loadVoiceConfiguration(for: currentItem)
                self.config = databaseManager.sessionConfiguration
                
            } catch {
                
                print("Error loading default voice selection: \(error.localizedDescription)")
            }
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
    
    func loadVoiceConfiguration(for voice: AddOnItem) async {
        do {
            let newConfig = try await configManager.loadVoiceConfiguration(for: voice)
            self.config = newConfig
            print("Loaded up AddOn voice configuration successfully")
            
        } catch {
            print("Failed to load configuration: \(error)")
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

#Preview {
    let user = User()
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    return MainView(logStatus: true)
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
        .environmentObject(user)
}
