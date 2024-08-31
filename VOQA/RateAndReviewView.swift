//
//  RateAndReviewView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/31/24.
//

import SwiftUI
import Foundation

struct RateAndReviewView: View {
    @State private var review = RatingsAndReview() // State to hold the updated review information
    @State private var isCommentModalPresented: Bool = false // State to manage modal presentation
    @State private var currentComment: String = "" // Temporary state for non-optional comment text

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header Text
            Text("Rate and Review")
                .font(.title3)
                .bold()
                .padding(.bottom, 10)
            
            // Ratings Section for Narration
            RatingSectionView(
                title: "Narration",
                currentRating: $review.narrationRating
            )
            
            // Ratings Section for Difficulty
            RatingSectionView(
                title: "Difficulty",
                currentRating: $review.difficultyRating
            )
            
            // Ratings Section for Relevance
            RatingSectionView(
                title: "Relevance",
                currentRating: $review.relevanceRating
            )
            
            // Comment Box
            CommentBoxView {
                // Update currentComment with review.comment or an empty string
                currentComment = review.comment ?? ""
                isCommentModalPresented.toggle()
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isCommentModalPresented) {
            // Use a Binding to the temporary state variable
            CommentModalView(comment: $currentComment)
                .onDisappear {
                    // Update review.comment with currentComment when modal is dismissed
                    review.comment = currentComment.isEmpty ? nil : currentComment
                }
        }
    }
}

#Preview {
    RateAndReviewView()
        .preferredColorScheme(.dark)
}

struct RatingSectionView: View {
    let title: String
    @Binding var currentRating: Int?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.trailing, 100)
            
            
            RatingsView(maxRating: 5, currentRating: $currentRating, width: 30, color: getColor(), sfSymbol: "star")
        }
    }
    
    func getColor() -> UIColor {
        return  currentRating != nil ? .systemTeal : .gray
    }
}

struct CommentBoxView: View {
    let action: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 100)
            .overlay(
                Text("Leave a Review")
                    .foregroundColor(.gray)
                    .padding()
            )
            .cornerRadius(10)
            .onTapGesture {
                action()
            }
    }
}




