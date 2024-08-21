//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = false
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        if logStatus {
            BaseView {
                HomePage()
            }
        } else {
            AppLaunch()
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
}

#Preview {
    let dbMgr = DatabaseManager.shared
    let ntwConn = NetworkMonitor.shared
    return ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(dbMgr)
        .environmentObject(ntwConn)
}
