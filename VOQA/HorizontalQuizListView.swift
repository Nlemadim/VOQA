//
//  HorizontalQuizListView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/21/24.
//

import Foundation
import SwiftUI

struct HorizontalQuizListView: View {
    var quizzes: [Voqa]
    var title: String
    var subtitle: String?
    let tapAction: (Voqa) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(title.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5)
                .padding(.horizontal)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(quizzes, id: \.self) { quiz in
                        ImageAndTitleView(title: quiz.acronym, imageUrl: quiz.imageUrl, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
