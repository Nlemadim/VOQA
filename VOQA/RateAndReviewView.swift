//
//  RateAndReviewView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/31/24.
//

import SwiftUI
import Foundation

struct RateAndReviewView: View {
    @Binding var review: RatingsAndReview
    @State private var isCommentModalPresented: Bool = false
    @State private var currentComment: String = ""
    
    let themeColor: Color
    var submitReview: () -> Void

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
                themeColor: themeColor,
                currentRating: $review.narrationRating
            )
            
            // Ratings Section for Difficulty
            RatingSectionView(
                title: "Difficulty",
                themeColor: themeColor,
                currentRating: $review.difficultyRating
            )
            
            // Ratings Section for Relevance
            RatingSectionView(
                title: "Relevance",
                themeColor: themeColor,
                currentRating: $review.relevanceRating
            )
            
            MediumDownloadButton(label: "Leave a review", color: .clear, iconImage: "") {
                isCommentModalPresented.toggle()
            }
            
            
            MediumDownloadButton(label: "Submit Ratings", color: themeColor, iconImage: "") {
                submitReview()
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isCommentModalPresented) {
            CommentModalView(comment: $currentComment, submitComment: { comment in
                review.comment = comment
            })
        }
    }
}

//#Preview {
//    RateAndReviewView(review: <#Binding<RatingsAndReview>#>, themeColor: .pink)
//        .preferredColorScheme(.dark)
//}

struct RatingSectionView: View {
    let title: String
    let themeColor: Color
    @Binding var currentRating: Int?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.trailing, 100)
            
            
            RatingsView(maxRating: 5, currentRating: $currentRating, width: 30, color: currentRating != nil ? themeColor : .gray, sfSymbol: "star")
        }
    }
}




