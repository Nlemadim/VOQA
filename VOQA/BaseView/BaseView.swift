//
//  BaseView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI
import SwiftData

struct BaseView<Content: View>: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var databaseManager = DatabaseManager.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared

 
    let content: () -> Content

    var body: some View {
        
        content()
            .preferredColorScheme(.dark)
            .onAppear {
                setupDataLayer()
            }
            .alert(item: $databaseManager.currentError) { error in
                Alert(
                    title: Text(error.title ?? "Error"),
                    message: Text(error.message ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(item: $networkMonitor.connectionError) { error in
                Alert(
                    title: Text(error.title ?? "Network Error"),
                    message: Text(error.message ?? "An unknown network error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay(
                databaseManager.showFullPageError ? fullPageErrorView : nil
            )
        
    }

    private func setupDataLayer() {
        // Setup any initial data or network calls here
    }

    var fullPageErrorView: some View {
        VStack {
            Text(databaseManager.currentError?.title ?? "Error")
                .font(.largeTitle)
                .padding()
            Text(databaseManager.currentError?.message ?? "An unknown error occurred.")
                .padding()
            Button(action: {
                // Handle retry logic here
                databaseManager.showFullPageError = false
            }) {
                Text("Retry")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}


