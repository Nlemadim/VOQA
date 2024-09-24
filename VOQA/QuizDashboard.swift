//
//  QuizDashboard.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/17/24.
//

import Foundation
import SwiftUI

struct QuizDashboard: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var networkMonitor: NetworkMonitor

    @Environment(\.quizSessionConfig) private var config: QuizSessionConfig?

    var voqa: Voqa

    @State var ratingsAndReviews = RatingsAndReview()
    @State private var contributeQuestion = ContributeAQuestion(questionText: "")
    @State private var activeTab: DashboardTab.TabItem = .quizzes
    @State private var dashboardTabScrollState: DashboardTab.TabItem?
    @State private var mainViewScrollState: DashboardTab.TabItem?
    @State private var dashboardTabs: [DashboardTab] = [
        .init(id: DashboardTab.TabItem.quizzes),
        .init(id: DashboardTab.TabItem.latestScores),
        .init(id: DashboardTab.TabItem.performance),
        .init(id: DashboardTab.TabItem.contribute),
        .init(id: DashboardTab.TabItem.rateAndReview)
    ]

    @State private var questionsLoaded: Bool = false
    @State private var isDownloading: Bool = false
    @State private var isLoadingScores: Bool = false
    @State var isLoggedIn: Bool
    @State private var selectedTopic: String?
    @State private var contributedQuestion: String = ""
    @State private var progress: CGFloat = .zero

    @State private var showConfigError: Bool = false

    var body: some View {

        VStack(spacing: 0) {
            HeaderView(voqa: voqa)
            DashboardTabBar()

            /// Main View
            GeometryReader { geometry in
                let size = geometry.size

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        /// Dashboard Tab label Views
                        ForEach(dashboardTabs) { tab in
                            ViewThatFits {
                                switch tab.id {
                                case .quizzes:
                                    
                                    QuizzesView(quizTopics: getCoreTopics(for: voqa) ?? []) { topicName in
                                        // Call the questions download here, when downloaded navigate to QuizPlayer view
                                        Task {
                                            do {
                                                try await databaseManager.fetchProcessedQuestions(
                                                    config: user.userConfig,
                                                    quizTitle :"MCAT",
                                                    questionTypeRequest: "All Categories",
                                                    maxNumberOfQuestions: 10
                                                )
                                                
                                                await navigateToQuizPlayer()
                                            } catch {
                                                print("Error fetching questions: \(error)")
                                                // Optionally show an alert
                                            }
                                        }
                                    }

                                case .latestScores:
                                    LatestScoresView(
                                        latestScore: databaseManager.latestScores,
                                        onRestartQuiz: {
                                            // Implement restart quiz logic
                                        },
                                        onStartNewQuiz: {
                                            // Implement start new quiz logic
                                        },
                                        isLoading: isLoadingScores,
                                        mainColor: Color.fromHex(voqa.colors.main),
                                        subColor: Color.fromHex(voqa.colors.sub)
                                    )

                                case .performance:
                                    PerformanceView(
                                        highScore: CGFloat(databaseManager.userHighScore),
                                        completedQuizzes: databaseManager.quizzesCompleted,
                                        mainColor: Color.fromHex(voqa.colors.main),
                                        subColor: Color.fromHex(voqa.colors.sub),
                                        performanceHistory: databaseManager.performanceHistory
                                    )

                                case .contribute:
                                    ContributeQuestionView(
                                        isLoggedIn: $isLoggedIn,
                                        themeColor: Color.fromHex(voqa.colors.main),
                                        submitQuestionText: { contributedQuestion in
                                            postQuestion(questionText: contributedQuestion)
                                        }
                                    )

                                case .rateAndReview:
                                    RateAndReviewView(
                                        review: $ratingsAndReviews,
                                        themeColor: Color.fromHex(voqa.colors.main),
                                        submitReview: {
                                            postReview(review: self.ratingsAndReviews)
                                        }
                                    )
                                }
                            }
                            .frame(width: size.width, height: size.height)
                            .contentShape(Rectangle())
                        }
                    }
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                }
                /// To track current tab selection and adjust scroll view accordingly. NOTE: scrollPosition Must match the precise data type of the id supplied in the ForEach Loop
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                /// Available from iOS 17. Any view placed within Scrollview Page view must have full width.
                .scrollTargetBehavior(.paging)
                /// Updating tabItem scroll view on page change
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    if let newValue {
                        withAnimation(.snappy) {
                            dashboardTabScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }
            }
        }
        .background(backgroundImageView)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showConfigError) {
            Alert(
                title: Text("Configuration Error"),
                message: Text("Quiz configuration is not available. Please try again later."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func getCoreTopics(for voqa: Voqa) -> [String]? {
        if let quizData = databaseManager.quizCollection.first(where: { $0.id == voqa.id }) {
            var quizTopics: [String] = []
            let communityTopics = "Community Questions"
            quizTopics.append(communityTopics)
            quizTopics.append(contentsOf: quizData.coreTopics)
            return quizTopics
        }
        return nil
    }

    private var backgroundImageView: some View {
        CachedImageView(imageUrl: voqa.imageUrl)
            .aspectRatio(contentMode: .fill)
            //.blur(radius: 3.0)
            .offset(x: -100)
            .overlay {
                Rectangle()
                    .foregroundStyle(.black.opacity(0.95))
            }
    }

    private func getQuestions(quizTitle: String, questionTypeRequest: String, number: Int) async {
        isDownloading = true
        do {
            try await databaseManager.fetchProcessedQuestions(config: user.userConfig, quizTitle: quizTitle, questionTypeRequest: questionTypeRequest, maxNumberOfQuestions: number)
            isDownloading = false
        } catch {
            isDownloading = false
            print("Error fetching questions: \(error)")
        }
    }

    private func navigateToQuizPlayer() async {
        print("Current Config before guard: \(String(describing: config))")
        guard let config = config, !config.sessionQuestion.isEmpty else {
            print("Failed to load session Questions")
            showConfigError = true
            return
        }
        
        print("Navigating to QuizPlayer with config: \(config)")
        navigationRouter.navigate(to: .quizPlayer(config: config, voqa: voqa))
    }

    private func postQuestion(questionText: String) {
        guard !questionText.isEmptyOrWhiteSpace else { return }
        self.contributeQuestion.questionText = questionText
        databaseManager.postNewQuestion(contributeQuestion)
    }

    private func postReview(review: RatingsAndReview) {
        guard review.difficultyRating != 0 || review.narrationRating != 0 || review.relevanceRating != 0 else { return }
        databaseManager.postNewReview(review)
    }

    @ViewBuilder
    func HeaderView(voqa: Voqa) -> some View {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundStyle(.white)
                .activeGlow(.white, radius: 1)
                .padding(.vertical)
                .allowsHitTesting(true)
                .onTapGesture {
                    navigationRouter.goBack()
                }

            Spacer()

            Text(voqa.acronym)
                .font(.title3.bold())
                .primaryTextStyleForeground()
        }
        .padding(15)
        /// Divider
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.white.opacity(0.3))
                .frame(height: 1)
        }
    }

    @ViewBuilder
    func DashboardTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($dashboardTabs) { $tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            mainViewScrollState = tab.id
                            dashboardTabScrollState = tab.id
                        }
                    }) {
                        Text(tab.id.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ? Color.primary : .gray)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
            /// Setting Tab bar to center once tabItem is tapped
            .scrollTargetLayout()
        }
        /// Setting the get property to update the scroll position
        .scrollPosition(id: .init(get: {
            return dashboardTabScrollState
        }, set: { _ in
            // Do nothing
        }), anchor: .center)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                let inputRange = dashboardTabs.indices.compactMap { CGFloat($0) }
                let outputRange = dashboardTabs.compactMap { $0.size.width }
                let outputPositionRange = dashboardTabs.compactMap { $0.minX }

                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)

                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
}

struct DashboardTab: Identifiable {
    private(set) var id: TabItem
    var size: CGSize = .zero
    var minX: CGFloat = .zero

    enum TabItem: String, CaseIterable {
        case quizzes = "Quizzes"
        case latestScores = "Latest Scores"
        case performance = "Performance"
        case contribute = "Contribute a Question"
        case rateAndReview = "Rate and Review"
    }
}


#Preview {
    let dbMgr = DatabaseManager.shared
    let user = User()
    let navMgr = NavigationRouter()
    return MyChannels(hideTabBar: .constant(false))
        .environmentObject(user)
        .environmentObject(dbMgr)
        .environmentObject(navMgr)
}


/**
 Task {
     await getQuestions(quizTitle: "MCAT", questionTypeRequest: "ALL Categories", number: 10)
 }
 
 */
