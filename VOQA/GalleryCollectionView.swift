//
//  GalleryCollectionView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct GalleryCollectionView: View {
    var quizzes: [PacketCover]
    var title: String
    var subtitle: String?
    let tapAction: (PacketCover) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(title.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5)
                .padding(.horizontal)
                .lineLimit(1)
                .truncationMode(.tail)
                .hAlign(.leading)
                .accessibilityAddTraits(.isHeader)
                       
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .padding(.horizontal)
                    .hAlign(.leading)
                    .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .accessibilityLabel(Text(subtitle))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(quizzes.enumerated()), id: \.element.id) { _, quiz in
                        ImageAndTitleView(title: quiz.title, titleImage: quiz.titleImage, tapAction: { _ in tapAction(quiz) }, packetCover: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(title) audio quiz"))
    }
}
