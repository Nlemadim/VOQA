//
//  HomePage.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/11/24.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var configManager = VoqaConfigManager()
    @StateObject private var databaseManager = DatabaseManager.shared
    @State private var selectedTab = 0
    @State private var collections: [VoqaCollection] = []
    @State private var errorMessage: IdentifiableError?
    @State private var selectedVoqa: Voqa?
    @State private var currentCategory: String = "VOQA"

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                FullTitlesScrollViewV1(collections: collections, tapAction: { quiz in
                    selectedVoqa = quiz
                }, selectedVoqa: $selectedVoqa, currentCategory: $currentCategory)
                .zIndex(1)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(currentCategory)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .kerning(-0.5)
                            .foregroundStyle(.primary)
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Text("Search")) {
                            Image(systemName: "magnifyingglass")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .onAppear {
                    Task {
                        do {
                            collections = try await configManager.loadFromBundle(bundleFileName: "HomepageConfig")
                        } catch {
                            errorMessage = IdentifiableError(message: "Error loading collections: \(error)")
                            print(errorMessage?.message ?? "")
                        }
                    }
                }
                .alert(item: $errorMessage) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                .fullScreenCover(item: $selectedVoqa) { voqa in
                    QuizInfoView(selectedVoqa: voqa)
                }
            }
            .tabItem {
                TabIcons(title: "Home", icon: "square.grid.2x2")
            }
            .tag(0)
            
            ProfileView()
                .tabItem {
                    TabIcons(title: "Performance", icon: "chart.bar.fill")
                }
                .tag(1)
            
            PerformanceView()
                .tabItem {
                    TabIcons(title: "Profile", icon: "person.fill")
                }
                .tag(2)
                .tint(.white).activeGlow(.white, radius: 2)
        }
        .tint(.white).activeGlow(.white, radius: 2)
    }
}


#Preview {
    HomePage()
        .preferredColorScheme(.dark)
}


struct PerformanceView: View {
    var body: some View {
        Text("Placeholder Performance View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Placeholder Profile View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}














