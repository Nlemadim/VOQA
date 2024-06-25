//
//  MainView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var quizContext: QuizContext

    let config: HomePageConfig
    
    init(config: HomePageConfig) {
        let context = QuizContext(state: IdleState())
        let audioPlayer = AudioContentPlayer(context: context)
        let quizModerator = QuizModerator(context: context)
        context.audioPlayer = audioPlayer
        context.quizModerator = quizModerator
        _quizContext = StateObject(wrappedValue: context)
        self.config = config
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomePage(quizContext: quizContext, config: config)
                .tabItem {
                    TabIcons(title: "Home", icon: "house.fill")
                }
                .tag(0)
            
//            QuizPlayerPage(quizContext: quizContext, selectedTab: $selectedTab, expandSheet: .constant(false), config: config)
//                .tabItem {
//                    TabIcons(title: "Quiz player", icon: "play.circle")
//                }
//                .tag(1)
            
            ExploreView()
                .tabItem {
                    TabIcons(title: "Browse", icon: "square.grid.2x2")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    TabIcons(title: "My Library", icon: "books.vertical.fill")
                }
                .tag(3)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Text("VOQA")
                    .font(.title)
                    .fontWeight(.black)
                    .kerning(-0.5)
                    .primaryTextStyleForeground()
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20.0)
                }
            }
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor.black
            
        }
        .tint(.white).activeGlow(.white, radius: 2)
        .environmentObject(quizContext)
    }
}


struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .onAppear {
                // Actions when the view appears
            }
    }
}

struct ExploreView: View {
    var body: some View {
        Text("Explore View")
            .onAppear {
                // Actions when the view appears
            }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home View")
            .onAppear {
                // Actions when the view appears
            }
    }
}
