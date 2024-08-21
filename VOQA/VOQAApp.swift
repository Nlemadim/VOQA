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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(databaseManager)
                .environmentObject(networkMonitor)
        }
    }
}

#Preview {
    let monitor = NetworkMonitor.shared
    let databaseManager = DatabaseManager.shared
    return ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(monitor)
        .environmentObject(databaseManager)
}





