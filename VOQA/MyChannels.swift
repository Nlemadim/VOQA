//
//  MyChannels.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/17/24.
//

import Foundation
import SwiftUI

struct MyChannels: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var user: User
    @EnvironmentObject var databaseManager: DatabaseManager
    @Binding var hideTabBar: Bool

    @StateObject private var playlistManager: PlaylistManager

    init(hideTabBar: Binding<Bool>, user: User) {
        _hideTabBar = hideTabBar
        // Initialize PlaylistManager with UserConfig from user
        _playlistManager = StateObject(wrappedValue: PlaylistManager(userConfig: user.userConfig))
    }

    var body: some View {
        ZStack {
            ChannelsBackgroundView()  // Background view

            VStack {
                VStack {
                    if let voqa = user.currentUserVoqa {
                        ChannelPlaylistCarouselView2(voqa: voqa, playlistManager: playlistManager) {
                           //MARK: TODO:- Navigate to QuizPlayer after question downlosd
                        }
                        .onAppear {
                            let voqaID = voqa.id
                            // Only generate playlists if not already available
                            if playlistManager.playlists[voqaID]?.isEmpty ?? true {
                                playlistManager.generatePlaylists(for: voqa)
                                print("Playlists generated for voqaID: \(voqaID)")
                            } else {
                                print("Playlists already exist for voqaID: \(voqaID)")
                            }
                        }
                    } else {
                        EmptyChannelPlaylistView()
                    }
                }

                ChannelListView(voqaCollection: user.voqaCollection) { selectedVoqa in
                    hideTabBar = true
                    user.currentUserVoqa = selectedVoqa
                    
                    // Ensure the playlists are up-to-date when a new Voqa is selected
                    let voqaID = selectedVoqa.id
                    if playlistManager.playlists[voqaID]?.isEmpty ?? true {
                        playlistManager.generatePlaylists(for: selectedVoqa)
                        print("Playlists generated for newly selected voqaID: \(voqaID)")
                    } else {
                        print("Playlists already exist for newly selected voqaID: \(voqaID)")
                    }

                    navigationRouter.navigate(to: .quizDashboard(selectedVoqa))
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("My Channels")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Image(systemName: "tv")
                    Text("Dashboard")
                }
                .onTapGesture {
                    // Handle navigation to Dashboard
                }
            }
        }
        .onAppear {
            Task {
                await databaseManager.fetchQuizCollection()
                loadUserCollection()
                hideTabBar = false
            }
        }
    }

    private func loadUserCollection() {
        if !databaseManager.quizCollection.isEmpty {
            user.voqaCollection = databaseManager.quizCollection.map { Voqa(from: $0) }
            user.currentUserVoqa = user.voqaCollection.first
        }
    }
}





//struct MyChannels: View {
//    @EnvironmentObject var navigationRouter: NavigationRouter
//    @EnvironmentObject var user: User
//    @EnvironmentObject var databaseManager: DatabaseManager
//    @Binding var hideTabBar: Bool
//    
//    var body: some View {
//        ZStack {
//            ChannelsBackgroundView()  // Background view
//        
//            VStack {
//                
//                VStack {
//                    if let voqa = user.currentUserVoqa {
//                        ChannelPlaylistCarouselView(voqa: voqa) {
//                            // Tap action can be implemented here if needed
//                        }
//                    } else {
//                        EmptyChannelPlaylistView()  // Show empty view when no Voqa is selected
//                    }
//                }
//                
//                ChannelListView(voqaCollection: user.voqaCollection) { selectedVoqa in
//                    hideTabBar = true
//              
//                    user.currentUserVoqa = selectedVoqa
//                    navigationRouter.navigate(to: .quizDashboard(selectedVoqa))
//                }
//                .listStyle(PlainListStyle())
//            }
//        }
//        .navigationTitle("My Channels")
//        .navigationBarTitleDisplayMode(.inline)
//        .preferredColorScheme(.dark)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                HStack {
//                    Image(systemName: "tv") // Change to your desired image name
//                    Text("Dashboard")
//                }
//                .onTapGesture {
//                    
//                }
//            }
//        }
//        .onAppear {
//            Task {
//                await databaseManager.fetchQuizCollection()
//                loadUserCollection()
//                hideTabBar = false
//            }
//        }
//    }
//    
//    private func loadUserCollection() {
//        // Ensure this method handles any empty collections appropriately
//        if !databaseManager.quizCollection.isEmpty {
//            user.voqaCollection = databaseManager.quizCollection.map { Voqa(from: $0) }
//            user.currentUserVoqa = user.voqaCollection.first
//        }
//        
//        //MARK: TEST FUNCTION CALLS
//        //        user.voqaCollection = mockItems.map { Voqa(from: $0, id: UUID().uuidString) }
//        //        user.currentUserVoqa = user.voqaCollection.first
//    }
//}

#Preview {
    let dbMgr = DatabaseManager.shared
    let navRouter = NavigationRouter()
    let user = User()
    return   MyChannels(hideTabBar: .constant(false), user: user)
        .environmentObject(user)
        .environmentObject(dbMgr)
        .environmentObject(navRouter)
}


let mockItems: [Voqa] = [
    Voqa(from: MockVoqaItem(quizTitle: "World War II History",
                             acronym: "WWII",
                             about: "Study the pivotal events, key figures, and global impact of World War II through this engaging quiz.",
                             imageUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/VoqaCollection/WorldWar2/WorldWar2.png",
                             colors: ThemeColors(main: "#8E44AD", sub: "#9B59B6", third: "#34495E")), id: UUID().uuidString)
]


struct ChannelPlaylistCarouselView: View {
    var voqa: Voqa  // Accept a single Voqa item
    @State private var currentItem: Int = 0  // Track the current item index in the tab view
    let tapAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Audio Quiz Playlist")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)

            TabView(selection: $currentItem) {
                ForEach(quizCategories.indices, id: \.self) { index in
                    let category = quizCategories[index]
                    HStack(spacing: 4) {
                        // Use CachedImageView for image display
                        CachedImageView(imageUrl: voqa.imageUrl)
                            .frame(width: 160, height: 200)
                            .padding(.horizontal)
                            .cornerRadius(15.0)
                        
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)

                            if category.isLocked {
                                Text(category.subtitle ?? "")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.bottom)
                    .onTapGesture {
                        tapAction()  // Call the action when tapped
                    }
                    .tag(index)  // Tag for TabView indexing
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 300)
        }
    }

    // Computed property for quiz categories based on the Voqa item
    var quizCategories: [QuizSelection] {
        // This example assumes categories are derived from the Voqa item or other data sources
        let topics = ["All Categories", "Learning Path", "Community Questions"] // Example topics
        return topics.map { topicName in
            let isLocked = ["All Categories", "Learning Path", "Community Questions"].contains(topicName)
            let subtitle: String? = isLocked ? "Subscribe to Unlock" : nil
            let icon = "" // Optional icon based on your requirements
            
            return QuizSelection(name: topicName, subtitle: subtitle, isLocked: isLocked, iconName: icon)
        }
        .sorted {
            !$0.isLocked && $1.isLocked  // Sort unlocked categories first
        }
    }
}


struct EmptyChannelPlaylistView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Empty Playlist")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)

            TabView {
                // This can be used to show a message or placeholder in case of no categories
                VStack {
                    Text("Join A Quiz Channel")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 350)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 350)
        }
    }
}
