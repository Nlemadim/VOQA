//
//  VoqaCollectionView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//


import Foundation
import SwiftUI

struct VoqaCollectionView: View {
    var category: String
    var subtitle: String
    var quizzes: [Voqa]
    let tapAction: (Voqa) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(category.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5)
                .padding(.horizontal)
                .lineLimit(1)
                .truncationMode(.tail)
                .hAlign(.leading)

            Text(subtitle)
                .font(.footnote)
                .padding(.horizontal)
                .hAlign(.leading)
                .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(quizzes) { quiz in
                        ImageAndTitleView(title: quiz.acronym, imageUrl: quiz.imageUrl, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
