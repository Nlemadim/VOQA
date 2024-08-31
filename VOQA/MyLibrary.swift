//
//  MyLibrary.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

import SwiftUI

struct MyLibrary: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var path = NavigationPath()
    @Binding var hideTabBar: Bool

    var body: some View {
        NavigationStack(path: $path) {
            LibraryListView(voqaCollection: user.voqaCollection) { selectedVoqa in
                hideTabBar = true
                user.currentUserVoqa = selectedVoqa
                path.append(PageNavigationController(type: .quizPlayerDetails(selectedVoqa)))
            }
            .listStyle(PlainListStyle())
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await databaseManager.fetchQuizCollection()
                    loadUserCollection()
                    hideTabBar = false
                   // handleNavigationLogicOnAppear()
                }
            }
            .navigationDestination(for: PageNavigationController.self) { destination in
                switch destination.type {
                case .quizInfo(let voqa):
                    QuizInfoView(selectedVoqa: voqa)
                case .quizPlayerDetails(let voqa):
                    QuizDashboardPage(voqa: voqa) { voqa in
                        path.append(PageNavigationController(type: .quizInfo(voqa)))
                       
                            
                    }
                case .quizPlayerView:
                    CreateAccountView()
                }
            }
        }
    }

    private func loadUserCollection() {
        user.voqaCollection = databaseManager.quizCollection.map { Voqa(from: $0) }
        user.currentUserVoqa = user.voqaCollection.first
    }

    private func handleNavigationLogicOnAppear() {
        // Check if user has a selected Voqa
        if let selectedVoqa = user.currentUserVoqa {
            // Navigate to QuizActivityView if a Voqa is selected
            path.append(PageNavigationController(type: .quizPlayerDetails(selectedVoqa)))
        }
    }
}


#Preview {
    let dbMgr = DatabaseManager.shared
    return MyLibrary(hideTabBar: .constant(false))
        .environmentObject(User())
        .environmentObject(dbMgr)
}
