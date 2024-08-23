//
//  VOQAApp.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import Firebase

@main
struct VOQAApp: App {
    @StateObject private var databaseManager = DatabaseManager.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @StateObject private var user = User()  // Adding User as a StateObject

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
                .environmentObject(user)  // Passing User to the environment
        }
    }
}

#Preview {
    let monitor = NetworkMonitor.shared
    let databaseManager = DatabaseManager.shared
    let user = User()  // Initialize User for Preview

    return ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(monitor)
        .environmentObject(databaseManager)
        .environmentObject(user)  // Add User to Preview environment
}





