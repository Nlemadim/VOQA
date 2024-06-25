//
//  QuizPlayerPage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation
import SwiftUI
import SwiftData

struct QuizPlayerPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var quizContext: QuizContext
    @ObservedObject var connectionMonitor = NetworkMonitor.shared
    @StateObject private var generator = ColorGenerator()
    
    @Query(sort: \Performance.id) var performanceCollection: [Performance]

    @State private var answeredQuestions: Int = UserDefaultsManager.totalQuestionsAnswered()
    @State private var questionCount: Int = UserDefaultsManager.numberOfTestQuestions()
    @State private var quizzesCompleted: Int = UserDefaultsManager.numberOfQuizSessions()
    
    @State var currentPerformance: [Performance] = []
    
    @Binding var selectedTab: Int
    
    @State var expandSheet: Bool = false
    @State var currentQuestionIndex: Int = 0
    @State var userHighScore: Int = 0
    
    @State var quizName = UserDefaultsManager.quizName()
    
    var config: HomePageConfig

    var body: some View {
        
        
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                )
            
            VStack(alignment: .center) {
                Image("VoqaIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .frame(height: 280)
            .blur(radius: 60)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(spacing: 5) {
                        Image("VoqaIcon")
                            .resizable()
                            .frame(width: 220, height: 220)
                            .cornerRadius(20)
                            .padding()
                                                
                        VStack(spacing: 0) {
                            HStack(spacing: 4) {
                                Spacer()
                                Text("Start".uppercased())
                                    .kerning(0.5)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                CircularPlayButton(
                                    quizContext: quizContext,
                                    isDownloading: $quizContext.isDownloading,
                                    color: generator.dominantBackgroundColor,
                                    playAction: { expandSheet = true }
                                    /Users/tonynlemadim/Documents/VoqaApp/VOQA/VOQA/MiniPlayer.swift                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 280)
                    .padding()
                    .padding(.horizontal, 40)
                    .hAlign(.center)
                }
                .padding()
                
                Divider()
                    .foregroundStyle(generator.dominantLightToneColor)
                    .activeGlow(generator.dominantLightToneColor, radius: 1)
                
                VStack {
                    
                    if let nowPlaying = config.nowPlaying {
                        NowPlayingView(
                            nowPlaying: nowPlaying,
                            generator: generator,
                            questionCount: 0, // Modify later
                            currentQuestionIndex: 0,
                            color: Color.primary,
                            quizContext: quizContext,
                            isDownloading: .constant(false),
                            playAction: { expandSheet = true }
                        )
                    }
                }
                .padding()
                .padding(.horizontal)
                
                Divider()
                    .foregroundStyle(generator.dominantLightToneColor)
                    .activeGlow(generator.dominantLightToneColor, radius: 1)
                
                PerformanceHistoryGraph(history: currentPerformance, mainColor: generator.enhancedDominantColor, subColor: .white.opacity(0.5))
                    .padding(.horizontal)
                
                VStack {
                    HeaderView(title: "Summary")
                        .padding()
                    
                    ActivityInfoView(answeredQuestions: answeredQuestions, quizzesCompleted: quizzesCompleted, highScore: userHighScore, numberOfTestsTaken: 0)
                }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: 100)
            }
        }
        .fullScreenCover(isPresented: $expandSheet) {
           FullScreenPlayer(quizContext: quizContext, expandSheet: $expandSheet)
        }
        .onAppear {
            filterPerformanceCollection()
            generator.updateAllColors(fromImageNamed: quizContext.quizTitleImage.isEmptyOrWhiteSpace ?  "VoqaIcon" : quizContext.quizTitleImage)
        }
    }

    private func userHighScore(from performances: [Performance]) -> Int {
        guard let highestScore = performances.map({ $0.score }).max() else {
            return 0
        }
        return Int(highestScore)
    }

    
    private func filterPerformanceCollection() {
        let quizName = ""
        
        // Filter the performanceCollection based on user's downloaded quiz name
        let filteredPerformance = performanceCollection.filter { $0.quizName == quizName }
        self.userHighScore = userHighScore(from: filteredPerformance)
        
        // Sort the filtered collection by date in descending order
        let sortedPerformance = filteredPerformance.sorted { $0.date > $1.date }
        
        // Limit the results to the seven most recent entries
        currentPerformance = Array(sortedPerformance.prefix(7))
        print("Loaded \(currentPerformance.count) performance records")
        print(filteredPerformance.first?.quizName ?? "Performance record Not found")
    }
    
    
    private func refreshQuizQuestions() {}
    
    private func startPlayer() {}
   
    private func renewQuiz() {}
    
    private func playSingleQuizQuestion() {}
        
    
    
    @ViewBuilder
    func ActivityInfoView(
        answeredQuestions: Int,
        quizzesCompleted: Int,
        highScore: Int,
        numberOfTestsTaken: Int
    ) -> some View {
        
        
        VStack(spacing: 15) {
            
            scoreLabel(
                withTitle: "Quizzes Completed",
                iconName: "doc.questionmark",
                score: "\(numberOfTestsTaken)"
            )
            
            scoreLabel(
                withTitle: "High Score",
                iconName: "trophy",
                score: "\(highScore)%"
            )
            
            scoreLabel(
                withTitle: "Total Number of Questions",
                iconName: "questionmark.circle",
                score: "∞"
            )
            
            scoreLabel(
                withTitle: "Questions Answered",
                iconName: "checkmark.circle",
                score: "\(answeredQuestions)"
            )
            
            scoreLabel(
                withTitle: "Questions Skipped",
                iconName: "arrowshape.bounce.forward",
                score: "\(0)"
            )
        }
        .padding()
        .background(Color.gray.opacity(0.07).gradient)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func scoreLabel(withTitle title: String, iconName: String, score: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(.mint)
            
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(score)
                .font(.subheadline)
        }
    }
}


struct HeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal)
        .hAlign(.leading)
    }
}

//#Preview {
//    let context = QuizContext(state: IdleState())
//    @State private var config = homePageConfig
//    return QuizPlayerPage(quizContext: context, selectedTab: .constant(1), config: config)
//}
