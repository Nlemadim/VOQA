//
//  VOQAApp.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

@main
struct VOQAApp: App {
    var sharedModelContainer: ModelContainer = {
        // Define the schema for the current version (version 1)
        let schemaV1 = Schema([
            StandardQuizPackage.self,
            CustomQuizPackage.self,
            Topic.self,
            Question.self,
            AudioQuiz.self,
            Performance.self,
            VoiceFeedbackMessages.self
        ])
        
        // Current app version
        let currentAppVersion = 1
        
        // Get stored app version from UserDefaults
        let storedAppVersion = AppVersion.current
        
        // Migration logic (placeholder for future use)
        if storedAppVersion < currentAppVersion {
            migrateData(from: storedAppVersion, to: currentAppVersion)
            AppVersion.current = currentAppVersion
        }
        
        // Use the schema for version 1
        let modelConfiguration = ModelConfiguration(schema: schemaV1, isStoredInMemoryOnly: false)

        // Initialize the ModelContainer
        do {
            return try ModelContainer(for: schemaV1, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

func migrateData(from oldVersion: Int, to newVersion: Int) {
    // Placeholder for future migration logic
    // For example, if oldVersion == 1 and newVersion == 2, perform necessary data migrations
    if oldVersion < 2 && newVersion >= 2 {
        // Perform migration logic here
    }
}

// AppVersion struct to manage the app version stored in UserDefaults
struct AppVersion {
    static var current: Int {
        get {
            return UserDefaults.standard.integer(forKey: "appVersion")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appVersion")
        }
    }
}

