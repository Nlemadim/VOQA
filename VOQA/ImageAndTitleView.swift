//
//  ImageAndTitleView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI

struct ImageAndTitleView: View {
    var title: String
    var titleImage: String
    let tapAction: (any QuizPackageProtocol) -> Void
    var quiz: any QuizPackageProtocol // Assume this is passed to the view

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(titleImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .cornerRadius(10.0)
                .clipped()
                .accessibilityLabel(Text("Quiz image"))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(title))
                
                Text(quiz.edition.descr)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .accessibilityLabel(Text(quiz.edition.descr))
                
                if let curator = quiz.curator {
                    Text("Curated by: " + curator)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .accessibilityLabel(Text("Curated by: \(curator)"))
                }
                
                if let users = quiz.users {
                    Text("\(users) users")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .accessibilityLabel(Text("\(users) users"))
                }
                
                if let rating = quiz.rating {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            if index <= rating {
                                Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.yellow)
                                    .accessibilityLabel(Text("Star filled"))
                            } else {
                                Image(systemName: "star")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                                    .accessibilityLabel(Text("Star"))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .padding(.bottom, 20)
        .onTapGesture {
            tapAction(quiz)
        }
        .accessibilityElement(children: .combine) // Combine all elements into a single accessibility element
        .accessibilityLabel(Text("Quiz: \(title)"))
    }
}

//#Preview {
//    ImageAndTitleView(title: <#String#>, titleImage: <#String#>, tapAction: <#(any QuizPackageProtocol) -> Void#>, quiz: <#any QuizPackageProtocol#>)
//}
