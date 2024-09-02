//
//  QuizCarouselView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//

import Foundation
import SwiftUI
import Shimmer


struct QuizCarouselView: View {
    var quizzes: [Voqa]
    @Binding var currentItem: Int
    @Binding var backgroundImage: String
    let tapAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Picks")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)

            TabView(selection: $currentItem) {
                ForEach(quizzes.indices, id: \.self) { index in
                    let quiz = quizzes[index]
                    VStack(spacing: 8) {
                        // Use CachedImageView for image display
                        CachedImageView(imageUrl: quiz.imageUrl)
                            .frame(width: 240, height: 240)
                            .cornerRadius(15.0)
                        
                        if !quiz.quizTitle.isEmpty {
                            Text(quiz.quizTitle)
                                .font(.callout)
                                .fontWeight(.black)
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                                .frame(width: 180)
                                .padding(.horizontal, 8)
                        } else {
                            // Shimmer effect for quiz title placeholder
                            Text("Loading title...")
                                .font(.callout)
                                .fontWeight(.black)
                                .lineLimit(3)
                                .multilineTextAlignment(.center)
                                .frame(width: 180)
                                .padding(.horizontal, 8)
                                .redacted(reason: .placeholder) // Use placeholder style
                                .shimmering(active: true) // Apply shimmering effect
                        }

                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= quiz.rating ? "star.fill" : "star")
                                    .imageScale(.small)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(.bottom)
                    .onTapGesture {
                        tapAction()
                    }
                    .onAppear {
                        backgroundImage = quiz.imageUrl // Update background
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 400)
        }
    }
}
