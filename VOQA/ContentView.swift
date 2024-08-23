//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = true
    @AppStorage("load_catalogue") private var loadCatalogue: Bool = true
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        VStack {
            if logStatus {
                MainView(logStatus: logStatus)
            } else {
                AppLaunch(loadCatalogue: loadCatalogue)
            }
        }
        .onAppear {
            Task {
                await getCatalogue()
            }
        }
    }
    
    private func getCatalogue() async {
        DispatchQueue.main.async {
            loadCatalogue = true
        }
        
        guard databaseManager.quizCollection.isEmpty else {
            DispatchQueue.main.async {
                loadCatalogue = false
            }
            
            return
        }
        
        Task {
            await databaseManager.fetchQuizCollection()
        }
        
        DispatchQueue.main.async {
            loadCatalogue = false
        }
    }
}

#Preview {
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    return ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
}

/**
 
 if logStatus {
     BaseView {
         HomePage()
     }
 } else {
     AppLaunch()
 }
 */


