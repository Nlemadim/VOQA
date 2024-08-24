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

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(user.voqaCollection, id: \.self) { voqa in
                    MyLibraryItemView(audioQuiz: voqa) { selectedVoqa in
                        // Navigate to QuizInfoView when the list item is tapped
                        path.append(PageNavigationController(type: .quizPlayerDetails(selectedVoqa)))
                        
                    } onDetailsTap: { selectedVoqa in
                        // Navigate to QuizPlayerDetails when the ellipsis button is tapped
                        path.append(PageNavigationController(type: .quizInfo(selectedVoqa)))
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("My Library")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await databaseManager.fetchQuizCollection()
                    loadUserCollection()
                }
            }
            .navigationDestination(for: PageNavigationController.self) { destination in
                switch destination.type {
                case .quizInfo(let voqa):
                    QuizInfoView(selectedVoqa: voqa)
                case .quizPlayerDetails(let voqa):
                    QuizActivityView(voqa: voqa)
                case .createAccount:
                    CreateAccountView()
                }
            }
        }
    }

    private func loadUserCollection() {
        user.voqaCollection = databaseManager.quizCollection.map { Voqa(from: $0) }
        user.currentUserVoqa = user.voqaCollection.first
    }
}

#Preview {
    MyLibrary()
        .environmentObject(User())
        .environmentObject(DatabaseManager.shared)
}



