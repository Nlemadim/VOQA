//
//  QuizInfoView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import SwiftUI
import UIKit

struct QuizInfoView: View {
    let selectedVoqa: Voqa
    @Environment(\.dismiss) private var dismiss
    @Environment(\.quizSessionConfig) private var config: QuizSessionConfig?
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var questionsLoaded: Bool = false
    @State private var isDownloading: Bool = false
    @State private var selectedTopic: String?

    var body: some View {
        VStack(spacing: 16) {
            disnissButton

            InfoHeaderView(
                mainTitle: "Quiz Overview",
                subtitle: selectedVoqa.quizTitle,
                description: "Select a category of questions"
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .hAlign(.leading)

            ExpandableSegmentedControl()
                .hAlign(.leading)
                .padding(.horizontal)

            if selectedTopic == nil {
                categoriesView()
            } else {
                selectedTopicView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(backgroundImageView)
        .alert(item: $databaseManager.currentError) { error in
            Alert(title: Text("Error"), message: Text(error.message ?? ""), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $questionsLoaded) {
            if let config = config {
                QuizPlayerView(config: config, selectedVoqa: selectedVoqa)
                    .environment(\.questions, databaseManager.questions)
                    .onDisappear { dismiss() }
            }
        }
    }

    private var disnissButton: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func categoriesView() -> some View {
        // Show the list of categories when no category is selected
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if let coreTopics = getCoreTopics(for: selectedVoqa) {
                    categoryButtonsView(coreTopics: coreTopics)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 80) // Extra padding for spacing
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private func selectedTopicView() -> some View {
        // Show the selected category and the download button when a category is selected
        VStack(spacing: 16) {
            // Display selected category
            if let selectedTopic = selectedTopic {
                QuizCategoryButton(
                    topicName: selectedTopic,
                    quizImage: selectedVoqa.imageUrl,
                    numberOfQuestions: 30,
                    isSelected: true
                )
                .padding(.horizontal)
            }

            // Download button with isDownloading state first
            DownloadButton(
                isDownloading: $isDownloading,
                label: "Download Questions",
                action: {
                    await getQuestions()
                },
                cancelAction: {
                    if isDownloading {
                        isDownloading = false
                        selectedTopic = nil
                        // Add any additional cancellation logic if needed
                    } else {
                        withAnimation {
                            selectedTopic = nil // Go back to category selection
                        }
                    }
                }
            )
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 16)
    }

    private func categoryButtonsView(coreTopics: [String]) -> some View {
        VStack {
            ForEach(coreTopics, id: \.self) { topic in
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedTopic = topic
                        HapticFeedback.selectionFeedback()
                    }
                }) {
                    QuizCategoryButton(
                        topicName: topic,
                        quizImage: selectedVoqa.imageUrl,
                        numberOfQuestions: 30,
                        isSelected: selectedTopic == topic
                    )
                    .padding(.vertical)
                }
                .transition(.move(edge: .leading))
                .opacity(selectedTopic == nil || selectedTopic == topic ? 1 : 0)
                .scaleEffect(selectedTopic == topic ? 1.1 : 1)
                .frame(maxWidth: selectedTopic == topic ? .infinity : .none)
                .animation(.easeInOut(duration: 0.3), value: selectedTopic)
            }
        }
    }

    private func getCoreTopics(for voqa: Voqa) -> [String]? {
        if let quizData = databaseManager.quizCollection.first(where: { $0.id == voqa.id }) {
            return quizData.coreTopics
        }
        return nil
    }

    private var backgroundImageView: some View {
        CachedImageView(imageUrl: selectedVoqa.imageUrl)
            .aspectRatio(contentMode: .fill)
            .blur(radius: 3.0)
            .offset(x: -100)
            .overlay {
                Rectangle()
                    .foregroundStyle(.black.opacity(0.6))
            }
    }

    private func getQuestions() async {
        isDownloading = true
        await databaseManager.fetchQuestions()
        isDownloading = false
        if !databaseManager.questions.isEmpty {
            questionsLoaded = true
        }
    }
}

struct InfoHeaderView: View {
    let mainTitle: String
    let subtitle: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mainTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)

            Text(subtitle)
                .font(.title2)
                .fontWeight(.bold)
                .primaryTextStyleForeground()
                .frame(maxWidth: .infinity)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}


struct ExpandableSegmentedControl: View {
    @State private var isExpanded: Bool = false
    @State private var rotationAngle: Double = 0

    var body: some View {
        HStack(spacing: isExpanded ? 8 : 0) {
            if isExpanded {
                Capsule()
                    .fill(Color.white.opacity(0.05)) // More ultrathin background
                    .frame(height: 40)
                    .overlay(
                        HStack(spacing: 16) {
                            Button(action: {
                                // Action for background music
                            }) {
                                Image(systemName: "music.note")
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                    .padding(.trailing)
                            }
                            
                            Divider().frame(height: 20).background(Color.white.opacity(0.8)) // Divider

                            Button(action: {
                                // Action for Q&A
                            }) {
                                Text("Q&A")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                    .padding(.trailing)
                            }
                            
                            Divider().frame(height: 20).background(Color.white.opacity(0.8)) // Divider

                            Button(action: {
                                // Action for timer
                            }) {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                    .padding(.trailing)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                    )
                    .transition(.opacity)
            }

            Button(action: {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isExpanded.toggle()
                    rotationAngle += 360
                }
            }) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    )
                    .rotationEffect(.degrees(rotationAngle)) // Rotation animation
            }
        }
        .padding(.horizontal, 4) // Adjust padding to position the button closer to the capsule
        .animation(.easeInOut, value: isExpanded)
    }
}






//#Preview {
//    // Mock data for Voqa
////    let mockVoqa = Voqa(
////        id: "1",
////        quizTitle: "Swift Programming Basics",
////        acronym: "SPB",
////        about: "An introduction to the basics of Swift programming language.",
////        imageUrl: "https://example.com/swift_basics.png",
////        rating: 4,
////        curator: "John Doe",
////        users: 1500,
////        tags: ["Swift", "Programming", "Basics"],
////        colors: ThemeColors(from: <#any Decoder#>, primary: "#FF5733", secondary: "#C70039"),
////        ratings: 5,
////        requiresSubscription: false
////    )
////
////    let dbMgr = DatabaseManager.shared
////    return QuizInfoView(selectedVoqa: )
////        .environmentObject(dbMgr)
////        .preferredColorScheme(.dark)
//
//}
//

