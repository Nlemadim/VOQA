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
    

    var body: some View {
        BaseView {
          HomePage()
                .onAppear {
                    printBundleResources()
                }
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
