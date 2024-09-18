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

    var body: some View {
        ChannelListView(voqaCollection: user.voqaCollection) { selectedVoqa in
            hideTabBar = true
            user.currentUserVoqa = selectedVoqa
            navigationRouter.navigate(to: .quizDashboard(selectedVoqa))
        }
        .listStyle(PlainListStyle())
        .navigationTitle("My VOQA Channels")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear {
            Task {
                await databaseManager.fetchQuizCollection()
                loadUserCollection()
                hideTabBar = false
                // handleNavigationLogicOnAppear()
            }
        }
    }

    private func loadUserCollection() {
        user.voqaCollection = databaseManager.quizCollection.map { Voqa(from: $0) }
        user.currentUserVoqa = user.voqaCollection.first
    }
}
