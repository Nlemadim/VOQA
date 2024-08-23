//
//  BaseView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import Foundation
import SwiftUI

struct BaseView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var path = NavigationPath()
    @State private var config: QuizSessionConfig?
    @State var logStatus: Bool
    var configManager = QuizConfigManager()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if logStatus {
                    if !databaseManager.quizCatalogue.isEmpty {
//                        Text("Catalogue ready!")
                        HomePage(quizCatalogue: databaseManager.quizCatalogue)
                    } else {
                        Text("Loading quizzes...")
                    }
                } else {
                    Text("App Sign In placeHolder")
                }
            }
            .environment(\.quizSessionConfig, config)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await setupQuizSessionConfig()
                    await databaseManager.fetchQuizCollection()
                }
                if !databaseManager.quizCatalogue.isEmpty {
                    print("Catalogue downloaded")
                }
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
    }

    private func setupQuizSessionConfig() async {
        do {
            let localConfig = try configManager.loadLocalConfiguration()
            self.config = localConfig
            print("Local configuration loaded successfully")
        } catch {
            print("Failed to load local configuration: \(error)")
            do {
                let downloadedConfig = try await configManager.downloadConfiguration()
                self.config = downloadedConfig
                print("Downloaded configuration loaded successfully")
            } catch {
                print("Failed to download configuration: \(error)")
            }
        }
    }

    var fullPageErrorView: some View {
        VStack {
            Text(databaseManager.currentError?.title ?? "Error")
                .font(.largeTitle)
                .padding()
            Text(databaseManager.currentError?.message ?? "An unknown error occurred.")
                .padding()
            Button(action: {
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



/**
 
 
 {
   "id": "WzNccgL8BIeWuHpb1KsX",
   "coreTopics": {
     "0": "Hardware and Mobile Devices",
     "1": "Networking and Troubleshooting",
     "2": "Operating Systems and Software Troubleshooting",
     "3": "Security and Operational Procedures",
     "4": "Learning Path",
     "5": "All Categories"
   },
   "about": "The CompTIA A+ certification is a foundational credential that validates the understanding of essential IT skills and knowledge, applicable across multiple industries. Founded by the Computing Technology Industry Association (CompTIA) in 1993, A+ certification has a crucial role in the career advancement of IT professionals...",
   "generalTopics": {
     "0": "PC Components",
     "1": "Storage Devices",
     "2": "Displays",
     "3": "Peripheral Devices",
     "4": "Mobile Devices",
     "5": "Network Architecture",
     "6": "Network Configuration",
     "7": "Networking Tools",
     "8": "Wireless Networking",
     "9": "TCP/IP Protocol Suite",
     "10": "Mobile Operating Systems",
     "11": "Mobile Device Connectivity",
     "12": "Mobile Device Synchronization",
     "13": "Windows Installation",
     "14": "Windows Configuration",
     "15": "Windows Maintenance",
     "16": "Windows Networking",
     "17": "MacOS Features",
     "18": "Linux Features",
     "19": "Virtualization",
     "20": "Cloud Computing Basics",
     "21": "Security Principles",
     "22": "Threats and Vulnerabilities",
     "23": "Security Solutions",
     "24": "Security Tools",
     "25": "Data Destruction and Disposal",
     "26": "Troubleshooting Methodologies",
     "27": "OS Troubleshooting",
     "28": "Application Troubleshooting",
     "29": "Security Issues",
     "30": "Hardware Failure Symptoms",
     "31": "Printer Issues",
     "32": "Network Connectivity",
     "33": "Wireless Troubleshooting",
     "34": "Best Practices for Safety",
     "35": "Environmental Impact",
     "36": "Communication and Professionalism",
     "37": "Change Management"
   },
   "quizTitle": "CompTIA A+",
   "imageUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/comptiaA/CompTIA_A.png",
   "colors": {
     "main": "#2C3E50",
     "sub": "#34495E",
     "third": "#2ECC71"
   },
   "curator": "",
   "ratings": 0,
   "users": 0,
   "catalogueGroup": "Professional Certifications",
   "acronym": "A+",
   "requiresSubscription": false,
   "tags": ["IT", "Hardware", "Certification"]
 },
 
 
 
 */
