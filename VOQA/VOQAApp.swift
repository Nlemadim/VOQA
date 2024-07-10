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
   

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
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

