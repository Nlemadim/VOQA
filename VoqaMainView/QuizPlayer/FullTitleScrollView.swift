//
//  FullTitleScrollView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/18/24.
//

import Foundation
import SwiftUI

// Define the FullTitlesScrollView model
struct FullTitlesScrollView: View {
    var collections: [VoqaCollection]
    var tapAction: (Voqa) -> Void
    @Binding var selectedVoqa: Voqa?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(collections) { collection in
                    Section(header: Text(collection.category).font(.title).bold()) {
                        ForEach(collection.quizzes) { quiz in
                            FullTitleView(quiz: quiz, tapAction: { _ in tapAction(quiz) })
                        }
                    }
                }
            }
            .padding()
        }
        .background {
            HomePageBackground()
        }
    }
}

// Usage example in the HomePage view
//struct HomePage2: View {
//    @StateObject private var configManager = VoqaConfigManager()
//    @State private var selectedTab = 0
//    @State private var collections: [VoqaCollection] = []
//    @State private var errorMessage: IdentifiableError?
//    @State private var selectedVoqa: Voqa?
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            NavigationStack {
//                FullTitlesScrollView(collections: collections, tapAction: { quiz in
//                    selectedVoqa = quiz
//                }, selectedVoqa: $selectedVoqa)
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Text("VOQA")
//                            .font(.title)
//                            .fontWeight(.black)
//                            .kerning(-0.5)
//                            .primaryTextStyleForeground()
//                    }
//                }
//                .onAppear {
//                    Task {
//                        do {
//                            collections = try await configManager.loadFromBundle(bundleFileName: "VoqaConfiguration")
//                        } catch {
//                            errorMessage = IdentifiableError(message: "Error loading collections: \(error)")
//                            print(errorMessage?.message ?? "")
//                        }
//                    }
//                }
//                .alert(item: $errorMessage) { error in
//                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
//                }
//                .fullScreenCover(item: $selectedVoqa) { voqa in
//                    let config = QuizSessionConfig() // Initialize the QuizSessionConfig as needed
//                    let controller = QuizController(sessionConfig: config)
//                    QuizPlayerView(controller: controller, selectedVoqa: voqa)
//                }
//            }
//            .tabItem {
//                TabIcons(title: "Home", icon: "square.grid.2x2")
//            }
//            .tag(0)
//
//            ProfileView()
//                .tabItem {
//                    TabIcons(title: "Performance", icon: "chart.bar.fill")
//                }
//                .tag(1)
//
//            PerformanceView()
//                .tabItem {
//                    TabIcons(title: "Profile", icon: "person.fill")
//                }
//                .tag(2)
//        }
//    }
//}
//
//// Example usage of FullTitlesScrollView in preview
//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
