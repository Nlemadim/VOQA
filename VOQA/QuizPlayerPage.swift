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
    @ObservedObject var connectionMonitor = NetworkMonitor.shared
    @StateObject private var generator = ColorGenerator()
    @StateObject private var context = QuizContext.create(state: IdleState())
    
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
                                Text("Start".uppercased())
                                    .kerning(0.5)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                CircularPlayButton(
                                    quizContext: context,
                                    isDownloading: $context.isDownloading,
                                    color: generator.dominantBackgroundColor,
                                    playAction: { expandSheet = true }
                                )
                            }
                            .hAlign(.center)
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
                    NowPlayingView(
                        nowPlaying: packetCover1,
                        generator: generator,
                        questionCount: 0, // Modify later
                        currentQuestionIndex: 0,
                        color: Color.primary,
                        quizContext: context,
                        isDownloading: .constant(false),
                        playAction: { expandSheet = true }
                    )
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
            FullScreenPlayer(quizContext: context, expandSheet: $expandSheet, configuration: config)
        }
        .onAppear {
            setUpQuizEnvironment()
            filterPerformanceCollection()
            generator.updateAllColors(fromImageNamed: context.quizTitleImage.isEmptyOrWhiteSpace ?  "VoqaIcon" : context.quizTitleImage)
        }
    }
    
    let packetCover1 = PacketCover(
        id: UUID(),
        title: "General Knowledge",
        titleImage: "IconImage",
        summaryDesc: "Test your general knowledge with this quiz package.",
        rating: 4,
        numberOfRatings: 100,
        edition: "basic",
        curator: "Quiz Master",
        users: 1000
    )
    
    static func createQuizContext(state: QuizState) -> QuizContext {
        let questionPlayer = QuestionPlayer()
        let moderator = QuizModerator()
        let context = QuizContext(state: state, questionPlayer: questionPlayer, quizModerator: moderator)
        // Ensure questionPlayer has a reference to the context
        questionPlayer.context = context
        return context
    }

    func setUpQuizEnvironment() {
        context.questions = newMockQuestions
        context.questionPlayer.questions = newMockQuestions // Ensure questionPlayer gets the questions
        print(context.questions.count)
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
    
    let newMockQuestions: [Question] = [
        Question(
            topicId: UUID(),
            content: "What is the capital of France?",
            options: ["Paris", "London", "Berlin", "Madrid"],
            correctOption: "D",
            isAnsweredCorrectly: true,
            numberOfPresentations: 1,
            ratings: 5,
            numberOfRatings: 100,
            audioScript: "What is the capital of France?",
            audioUrl: "smallVoiceOver",
            replayQuestionAudioScript: "Can you repeat the question?",
            replayOptionAudioScript: "Can you repeat the options?",
            status: .newQuestion,
            difficultyLevel: 1,
            answerPresentedDate: Date()
        ),
        Question(
            topicId: UUID(),
            content: "What is the largest planet in our Solar System?",
            options: ["Earth", "Mars", "Jupiter", "Saturn"],
            correctOption: "B",
            isAnsweredCorrectly: false,
            numberOfPresentations: 2,
            ratings: 4,
            numberOfRatings: 50,
            audioScript: "What is the largest planet in our Solar System?",
            audioUrl: "smallVoiceOver2",
            replayQuestionAudioScript: "Can you repeat the question?",
            replayOptionAudioScript: "Can you repeat the options?",
            status: .repeatQuestion,
            difficultyLevel: 2,
            answerPresentedDate: nil
        ),
        Question(
            topicId: UUID(),
            content: "What is the chemical symbol for water?",
            options: ["H2O", "O2", "CO2", "H2"],
            correctOption: "C",
            isAnsweredCorrectly: true,
            numberOfPresentations: 3,
            ratings: 3,
            numberOfRatings: 30,
            audioScript: "What is the chemical symbol for water?",
            audioUrl: "smallVoiceOver",
            replayQuestionAudioScript: "Can you repeat the question?",
            replayOptionAudioScript: "Can you repeat the options?",
            status: .modifiedQuestion,
            difficultyLevel: 1,
            answerPresentedDate: Date()
        ),
        Question(
            topicId: UUID(),
            content: "Who wrote 'Romeo and Juliet'?",
            options: ["William Shakespeare", "Charles Dickens", "Mark Twain", "Jane Austen"],
            correctOption: "A",
            isAnsweredCorrectly: false,
            numberOfPresentations: 1,
            ratings: 5,
            numberOfRatings: 80,
            audioScript: "Who wrote 'Romeo and Juliet'?",
            audioUrl: "smallVoiceOver2",
            replayQuestionAudioScript: "Can you repeat the question?",
            replayOptionAudioScript: "Can you repeat the options?",
            status: .followUp,
            difficultyLevel: 2,
            answerPresentedDate: nil
        )
    ]
        
    
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
