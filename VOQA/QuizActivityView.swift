//
//  QuizActivityView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

import Foundation
import SwiftUI

struct QuizActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage: String = "Latest Scores"
    @State private var isLoadingScores: Bool = false
    @Namespace private var animation
    
    var voqa: Voqa
    var onNavigateToQuizInfo: (Voqa) -> Void  
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HeaderView(voqa: voqa)
                
                PinnedHeaderView()
                
                VStack {
                    // Switch between different views based on currentPage
                    switch currentPage {
                    case "Latest Scores":
                        LatestScoresView(
                            latestScore: mockScore,
                            
                            onRestartQuiz: {
                                
                            },
                            onStartNewQuiz: {
                                
                            },
                            isLoading: isLoadingScores
                        )
                    case "Performance":
                        PerformanceView(
                            highScore: 90,
                            leaderboardScore: 117,
                            leaderboardMembers: 18890,
                            completedQuizzes: 70,
                            rank: "GOLD",
                            performances: mockHistory
                        )
                    case "Q&A History":
                        QnAHistoryView()
                    case "Test Topics":
                        TestTopicsView()
                    case "Contribute a Question":
                        ContributeQuestionView()
                            .frame(maxHeight: .infinity)
                    case "Rate and Review":
                        RateReviewView()
                    default:
                        Text("No content available")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .coordinateSpace(name: "SCROLL")
        .navigationBarBackButtonHidden(true)
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
        let pages: [String] = ["Latest Scores", "Performance", "Q&A History", "Test Topics", "Contribute a Question", "Rate and Review"]
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
            //.padding(.bottom, 25)
        }
    }
    
   
    @ViewBuilder
    func QnAHistoryView() -> some View {
        VStack {
            Text("Q&A History")
                .font(.title)
            // Add more UI elements for Q&A History here
        }
    }
    
    @ViewBuilder
    func TestTopicsView() -> some View {
        VStack {
            Text("Test Topics")
                .font(.title)
            // Add more UI elements for Test Topics here
        }
    }
    
    
    @ViewBuilder
    func RateReviewView() -> some View {
        VStack {
            Text("Rate and Review")
                .font(.title)
            // Add more UI elements for Rate and Review here
        }
    }
}

#Preview {
    return LatestScoresView(latestScore: mockScore , onRestartQuiz: {}, onStartNewQuiz: {}, isLoading: true)
        .preferredColorScheme(.dark)
}

#Preview {
    LatestScoresView(onRestartQuiz: {}, onStartNewQuiz: {}, isLoading: false)
        .preferredColorScheme(.dark)
}

#Preview {
    LatestScoresView(onRestartQuiz: {}, onStartNewQuiz: {}, isLoading: true)
        .preferredColorScheme(.dark)
}



struct LatestScore {
    var quizId: String
    var date: Date
    var quizCategory: String
    var numberOfquestions: String
    var review: String
    var score: String
}


struct LatestScoresView: View {
    var latestScore: LatestScore?
    var onRestartQuiz: () -> Void
    var onStartNewQuiz: () -> Void
    var isLoading: Bool
    @State private var isReviewExpanded = false

    var body: some View {
        if let score = latestScore {
            // When content is available
            VStack(alignment: .leading, spacing: 30) {
                // Top Leading Item: Latest Score
                HStack {
                    Text("Score:")
                        .foregroundColor(.primary)
                        .font(.headline)
                    //Spacer()
                    Text(score.score)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(scoreColor(for: score.score))
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Text("\(score.date.ISO8601Format())")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Quiz Category
                Text(score.quizCategory.uppercased())
                    .font(.title2)
                    .lineLimit(2, reservesSpace: false)
                    .fontWeight(.semibold)
                    .primaryTextStyleForeground()

                // Number of Questions
                HStack {
                    Text("Number of Questions:")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    Text(score.numberOfquestions)
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                // Correct and Wrong Answers
                HStack {
                    Text("Correct Answers:")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    Text(correctAnswers(for: score))
                        .foregroundColor(.green)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("Wrong Answers:")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    Text(wrongAnswers(for: score))
                        .foregroundColor(.red)
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                // Review Text with Expandable Button
                VStack(alignment: .leading, spacing: 4) {
                    Text(score.review)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(isReviewExpanded ? nil : 2)
                        .truncationMode(.tail)

                    if score.review.count > 100 {
                        Button(action: {
                            withAnimation {
                                isReviewExpanded.toggle()
                            }
                        }) {
                            Text(isReviewExpanded ? "Show Less" : "Show More")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                }

                // Buttons for Restart and Start a New Quiz
                VStack(spacing: 16) {
                    
                    MediumDownloadButton(label: "Restart", color: .teal, iconImage: "arrow.counterclockwise", action: {
                        onRestartQuiz()
                    })
                    
                    MediumDownloadButton(label: "New Quiz", color: .teal, iconImage: "", action: {
                        onStartNewQuiz()
                    })

                }
            }
            .padding()
            .padding(.top, 20)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal)
        } else {
            // No content view when latestScore is nil
            NoContentView(action: onStartNewQuiz, isLoadingScores: isLoading)
        }
    }

    // Helper function to determine score color
    private func scoreColor(for score: String) -> Color {
        guard let scoreValue = Int(score.trimmingCharacters(in: CharacterSet(charactersIn: "%"))) else {
            return .white
        }
        switch scoreValue {
        case ..<10:
            return .red
        case 10..<30:
            return .orange
        case 30..<50:
            return .yellow
        case 50..<70:
            return .white
        default:
            return .green
        }
    }

    // Mock function for correct answers - replace with real logic
    private func correctAnswers(for latestScore: LatestScore) -> String {
        // Implement your logic to calculate correct answers
        return "15" // Example value
    }

    // Mock function for wrong answers - replace with real logic
    private func wrongAnswers(for latestScore: LatestScore) -> String {
        // Implement your logic to calculate wrong answers
        return "5" // Example value
    }
}

// A view to display when there's no content available
struct NoContentView: View {
    var action: () -> Void
    var isLoadingScores: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                CustomSpinnerView()
                    .frame(height: 50)
            }
            .opacity(isLoadingScores ? 1 : 0)
            
            VStack(spacing: 10) {
                Spacer()
                
                Text("You Have No Scores Yet")
                    .font(.subheadline)
                
                MediumDownloadButton(label: "Start Assessment Quiz", color: .teal, iconImage: "", action: {
                    action()
                })
                .padding()
                
                Spacer()
            }
            .opacity(isLoadingScores ? 0 : 1)
        }
        .padding()
        .cornerRadius(12)
        .padding(.horizontal)
    }
}


let mockScore = LatestScore(
           quizId: "123",
           date: Date(),
           quizCategory: "Science",
           numberOfquestions: "20",
           review: "This quiz covered various topics in science, including biology, chemistry, and physics. The questions were challenging and tested the understanding of key concepts.",
           score: "75%"
       )
