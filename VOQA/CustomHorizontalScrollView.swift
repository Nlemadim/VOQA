//
//  CustomHorizontalScrollView.swift
//  VoqaMainView
//
//  Created by Tony Nlemadim on 7/8/24.
//

import SwiftUI

struct CustomHorizontalScrollView: View {
    var quizzes: [Voqa]
    var title: String
    var subtitle: String?
    let tapAction: (Voqa) -> Void

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
                       
            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .padding(.horizontal)
                    .hAlign(.leading)
                    .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(quizzes, id: \.self) { quiz in
                        ImageAndTitleView(title: quiz.acronym, titleImage: quiz.imageUrl, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    CustomHorizontalScrollView(quizzes: voqas, title: "Top Rated", tapAction: {_ in })
}

let voqas: [Voqa] = [
    Voqa(id: UUID(), name: "Nature Sounds Quiz", acronym: "NSQ", about: "A quiz that challenges you to identify different nature sounds.", imageUrl: "Azure-Pro", rating: 4, curator: "John Doe", users: 200),
    Voqa(id: UUID(), name: "History Facts Quiz", acronym: "HFQ", about: "Test your knowledge on historical facts.", imageUrl: "AmericanHistory-Exam", rating: 5, curator: "Jane Smith", users: 150),
    Voqa(id: UUID(), name: "Music Trivia Quiz", acronym: "MTQ", about: "Identify songs and artists from different eras.", imageUrl: "Azure-Basic", rating: 4, curator: "Emily Johnson", users: 300),
    Voqa(id: UUID(), name: "Science Quiz", acronym: "SCQ", about: "Challenge your knowledge in various scientific fields.", imageUrl: "Adv-Math-Exam", rating: 5, curator: "Mark Brown", users: 100),
    Voqa(id: UUID(), name: "Literature Quiz", acronym: "LQ", about: "A quiz for literature enthusiasts.", imageUrl: "CISA-Exam", rating: 3, curator: "Sarah Davis", users: 120)
]
