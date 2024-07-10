//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var config: QuizSessionConfig?
    @State private var showTestView = false

    var body: some View {
        VStack {
            Text("Hello VOQA")
                .font(.largeTitle)
                .padding()

            Button(action: {
                Task {
                    await downloadQuizConfiguration()
                }
            }) {
                Text("Download Configuration")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if let config = config, showTestView {
                TestConfigView(config: config)
            }
        }
        .onAppear {
            loadLocalConfiguration()
        }
    }

    private func loadLocalConfiguration() {
        let configManager = QuizConfigManager()

        do {
            let localConfig = try configManager.loadLocalConfiguration()
            self.config = localConfig
            self.showTestView = true
            print("Local configuration loaded successfully")
        } catch {
            print("Failed to load local configuration: \(error)")
        }
    }

    private func downloadQuizConfiguration() async {
        let configManager = QuizConfigManager()

        do {
            let downloadedConfig = try await configManager.downloadConfiguration()
            DispatchQueue.main.async {
                self.config = downloadedConfig
                self.showTestView = true
            }
        } catch {
            print("Failed to download configuration: \(error)")
        }
    }
}



#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

