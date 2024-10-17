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
    @StateObject private var navigationRouter = NavigationRouter()
    @StateObject private var databaseManager = DatabaseManager.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @StateObject private var user = User()  // Adding User as a StateObject

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationRouter)
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





/**
 
 error: Build input files cannot be found: '/Users/tonynlemadim/Documents/FLAQ-BETA/Exam Genius/Utilities/VoqaWave.swift', '/Users/tonynlemadim/Documents/FLAQ-BETA/Exam Genius/Utilities/VoqaWaveView.swift', '/Users/tonynlemadim/Documents/FLAQ-BETA/Exam Genius/Utilities/SupportLine.swift', '/Users/tonynlemadim/Documents/FLAQ-BETA/Exam Genius/Utilities/WaveGeometry.swift'. Did you forget to declare these files as outputs of any script phases or custom build rules which produce them? (in target 'VOQA' from project 'VOQA')
 */
