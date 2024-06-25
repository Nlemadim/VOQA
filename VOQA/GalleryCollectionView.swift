//
//  GalleryCollectionView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct GalleryCollectionView: View {
    var quizzes: [any QuizPackageProtocol]
    var title: String
    var subtitle: String?
    let tapAction: (any QuizPackageProtocol) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(title.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5) // Reduces the default spacing between characters
                .padding(.horizontal)
                .lineLimit(1) // Ensures the text does not wrap
                .truncationMode(.tail) // Adds "..." at the end if the text is too long
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
                    ForEach(quizzes.indices, id: \.self) { index in
                        let quiz = quizzes[index]
                        ImageAndTitleView(title: quiz.title, titleImage: quiz.titleImage, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
        .accessibilityElement(children: .combine) // Combine all elements into a single accessibility element
        .accessibilityLabel(Text("\(title) audio quiz"))
    }
}

//#Preview {
//    GalleryCollectionView(quizzes: <#[any QuizPackageProtocol]#>, title: <#String#>, tapAction: <#(any QuizPackageProtocol) -> Void#>)
//}
