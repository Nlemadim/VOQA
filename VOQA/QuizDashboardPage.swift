//
//  QuizDashboardPage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import Foundation
import SwiftUI


struct QuizDashboardPage: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var contributeQuestion = ContributeAQuestion(questionText: "")
    @State var ratingsAndReviews = RatingsAndReview()
    @State private var contributedQuestion: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage: String = "Latest Scores"
    @State private var isLoadingScores: Bool = false
    @State var isLoggedIn: Bool
    @Namespace private var animation
    
    var voqa: Voqa
    var onNavigateToQuizInfo: (Voqa) -> Void  // Callback to handle navigation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HeaderView(voqa: voqa)
                
                PinnedHeaderView()
                
                ViewThatFits {
                    VStack(alignment: .center) {
                        switch currentPage {
                        case "Latest Scores":
                            LatestScoresView(
                                
                                latestScore: databaseManager.latestScores,
                                
                                onRestartQuiz: {
                                    
                                },
                                onStartNewQuiz: {
                                    
                                },
                                isLoading: isLoadingScores,
                                
                                mainColor: Color.fromHex(voqa.colors.main),
                                
                                subColor: Color.fromHex(voqa.colors.sub)
                            )
                            
                        case "Performance":
                            PerformanceView(
                                
                                highScore: CGFloat(databaseManager.userHighScore),
                                
                                completedQuizzes: databaseManager.quizzesCompleted,
                                
                                mainColor: Color.fromHex(voqa.colors.main),
                                
                                subColor: Color.fromHex(voqa.colors.sub),
                                
                                performanceHistory: databaseManager.performanceHistory
                            )
                            
                        case "Contribute a Question":
                            ContributeQuestionView(
                                
                                isLoggedIn: $isLoggedIn,
                                
                                themeColor: Color.fromHex(voqa.colors.main),
                                
                                submitQuestionText: { contributedQuestion in
                                    
                                postQuestion(questionText: contributedQuestion)
                                    
                            })
                            
                        case "Rate and Review":
                            RateAndReviewView(
                                
                                review: $ratingsAndReviews,
                                
                                themeColor: Color.fromHex(voqa.colors.main),
                                
                                submitReview: {
                                    
                                    postReview(review: self.ratingsAndReviews)
                            })
             
                        default:
                            Text("No content available")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .coordinateSpace(name: "SCROLL")
        .navigationBarBackButtonHidden(true)
    }
    
    private func postQuestion(questionText: String) {
        guard !questionText.isEmptyOrWhiteSpace else { return }
        self.contributeQuestion.questionText = questionText
        databaseManager.postNewQuestion(contributeQuestion)
    }
    
    private func postReview(review: RatingsAndReview) {
        guard review.difficultyRating != 0 || review.narrationRating != 0 || review.relevanceRating != 0  else { return }
        databaseManager.postNewReview(review)
    }
    
    @ViewBuilder
    func HeaderView(voqa: Voqa) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            CachedImageView(imageUrl: voqa.imageUrl)
                .frame(width: size.width, height: height, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        // Dimming out text Content
                        LinearGradient(colors: [
                            .clear,
                            .black.opacity(0.5),
                            .black.opacity(0.9)
                        ], startPoint: .top, endPoint: .bottom)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.white)
                                    .activeGlow(.white, radius: 1)
                                    .padding(.vertical)
                                    .allowsHitTesting(true)
                                    .onTapGesture {
                                        dismiss()
                                    }
                                
                                Spacer()
                                
                                Text(voqa.acronym)
                                    .font(.title.bold())
                                    .primaryTextStyleForeground()
                                
                                Label {
                                    Text("My Dashboard")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.7))
                                } icon: {}
                                    .font(.caption)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                    }
                }
                .cornerRadius(15)
                .offset(y: -minY)
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let pages: [String] = ["Latest Scores", "Performance", "Contribute a Question", "Rate and Review"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(pages, id: \.self) { page in
                    VStack(spacing: 12) {
                        Text(page)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(currentPage == page ? .white : .gray)
                        
                        ZStack {
                            if currentPage == page {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.white)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentPage = page
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
        }
    }
}

//#Preview {
//    return LatestScoresView1(latestScore: mockScore , onRestartQuiz: {}, onStartNewQuiz: {}, isLoading: true)
//        .preferredColorScheme(.dark)
//}
//
//#Preview {
//    LatestScoresView1(onRestartQuiz: {}, onStartNewQuiz: {}, isLoading: false)
//        .preferredColorScheme(.dark)
//}
//
//#Preview {
//    LatestScoresView1(onRestartQuiz: {}, onStartNewQuiz: {}, isLoading: true)
//        .preferredColorScheme(.dark)
//}
//





