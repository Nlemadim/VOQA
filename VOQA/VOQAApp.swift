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
    @State private var isContentReady: Bool = false
    @State private var isUserSignedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if isUserSignedIn {
                
                ContentView()
                
            } else {
                
                AppLaunch(isUserSignedIn: $isUserSignedIn)
            }
        }
    }
    
    func prepareContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isUserSignedIn = UserDefaults.standard.bool(forKey: "isUserSignedIn")
            isContentReady = true
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
    ContentView()
        .preferredColorScheme(.dark)
}





