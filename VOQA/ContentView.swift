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
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        BaseView(logStatus: logStatus)
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
