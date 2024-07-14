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

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(collections) { collection in
                            VoqaCollectionView(
                                category: collection.category,
                                subtitle: collection.subtitle,
                                quizzes: collection.quizzes,
                                tapAction: { quiz in
                                    selectedVoqa = quiz
                                }
                            )
                        }
                        
                        // Leave Rectangle
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 100)
                    }
                }
                .background {
                    HomePageBackground()
                }
                .zIndex(1)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Text("VOQA")
                            .font(.title)
                            .fontWeight(.black)
                            .kerning(-0.5)
                            .primaryTextStyleForeground()
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














