//
//  ExplorePage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/3/24.
//

import SwiftUI
import SwiftData

struct ExplorePage: View {
    
    @State private var searchText = ""
    @Binding var selectedTab: Int
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                            ForEach(filteredQuizzes, id: \.self) { quiz in
//                                let quizItem = MyPlaylistItem(from: quiz)
//                                AudQuizCardViewMid(quiz: quizItem)
//                                    .onTapGesture {
//                                        self.selectedQuizPackage = quiz
//                                    }
//                            }
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
//            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
//                QuizDetailPage(audioQuiz: selectedQuiz, selectedTab: $selectedTab)
//            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    ErrorTextView(errorMessage: "No internet connection")
//                        .opacity(!connectionMonitor.isConnected ? 1 : 0)
//                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by Name, Acronym or Category")
        }
    }
    
//    private var filteredQuizzes: [AudioQuizPackage] {
//        if searchText.isEmpty {
//            return audioQuizCollection
//        } else {
//            return audioQuizCollection.filter { quiz in
//                quiz.name.localizedCaseInsensitiveContains(searchText) ||
//                quiz.acronym.localizedCaseInsensitiveContains(searchText) ||
//                quiz.category.contains { $0.descr.localizedCaseInsensitiveContains(searchText) }
//            }
//        }
//    }
}

