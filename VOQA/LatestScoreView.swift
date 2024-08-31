//
//  LatestScoreView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import Foundation
import SwiftUI

struct LatestScoresView1: View {
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
                    
                    Text(formattedDate(for: score.date))
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
            .padding(.top, 20)
            .cornerRadius(12)
            .padding(.horizontal, 10)
        } else {
            // No content view when latestScore is nil
            NoContentView1(action: onStartNewQuiz, isLoadingScores: isLoading)
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
    
    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        
        // Check if the date is today
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "EEEE, h:mm a"  // "Wednesday, 5:00 PM"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"  // "Jan 1, 5:00 PM"
        }
        
        return formatter.string(from: date)
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
struct NoContentView1: View {
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
        .padding(.horizontal, 10)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
