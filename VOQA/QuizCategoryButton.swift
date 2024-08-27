//
//  QuizCategoryButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/26/24.
//

import SwiftUI

struct QuizCategoryButton: View {
    let topicName: String
    let quizImage: String
    let numberOfQuestions: Int
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(alignment: .top) {  // Align the content at the top
                CachedImageView(imageUrl: quizImage) // Use CachedImageView for URL loading
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(4)

                VStack(alignment: .leading, spacing: 4.0) {  // Adjusted spacing
                    Text(topicName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(2)  // Allow up to two lines for the topic name
                        .padding(.bottom, 4)  // Reduced bottom padding to align better

                    Text("\(numberOfQuestions) Questions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .lineLimit(1)  // Ensure this text stays on a single line
                }
                .padding(.leading, 8)  // Add padding only on the leading side
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .cornerRadius(5)
        .padding(.horizontal, 5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(isSelected ? Color.white : .gray, lineWidth: 0.5)
                .padding(.horizontal, 5)
        )
    }
}




struct LoadQuizCategory: View {
    let topicName: String
    let quizImage: String
    let numberOfQuestions: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                // Use AsyncImage or CachedImageView for loading images from URLs
                CachedImageView(imageUrl: quizImage)
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
                    .padding(.leading)

                VStack(spacing: 8.0) {
                    Text(topicName)
                        .font(.footnote)
                        .fontWeight(.light)
                        .lineLimit(3, reservesSpace: false)
                        .hAlign(.leading)
                    Text("\(numberOfQuestions) Questions")
                        .font(.footnote)
                        .fontWeight(.light)
                        .lineLimit(3, reservesSpace: false)
                        .hAlign(.leading)
                }
                .padding(8.0)
            }
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 0.5)
                .activeGlow(.white, radius: 1)
        )
    }
}
    

#Preview {
    QuizCategoryButton(topicName: "Biology".uppercased(), quizImage: "IconImage", numberOfQuestions: 35, isSelected: false)
        .preferredColorScheme(.dark)
}
