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
    @State private var config: QuizSessionConfig?

    var body: some View {
        BaseView {
            VoqaMain()
        }
    }
    
    func printBundleResources() {
        if let resourcePath = Bundle.main.resourcePath {
            do {
                let resourceContents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                print("Bundle Resources:")
                for resource in resourceContents {
                    print(resource)
                }
            } catch {
                print("Error accessing bundle resources: \(error)")
            }
        }
    }
    
    private func loadLocalConfiguration() {
        let configManager = QuizConfigManager()

        do {
            let localConfig = try configManager.loadLocalConfiguration()
            self.config = localConfig
            
            print("Local configuration loaded successfully")
        } catch {
            print("Failed to load local configuration: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
    
}
