//
//  MyLibraryItemView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

import Foundation
import SwiftUI

struct MyLibraryItemView: View {
    @EnvironmentObject var user: User
    var audioQuiz: Voqa
    var onTap: (Voqa) -> Void
    var onDetailsTap: (Voqa) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: user.currentUserVoqa?.acronym == audioQuiz.acronym ? "square.fill" : "square")
                .foregroundStyle(user.currentUserVoqa?.acronym == audioQuiz.acronym ? .teal : .gray)
            
            CachedImageView(imageUrl: audioQuiz.imageUrl)
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(audioQuiz.acronym)
                    .fontWeight(.semibold)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                onDetailsTap(audioQuiz) // Call the closure to navigate to QuizPlayerDetails
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.white)
            }
        }
        .onTapGesture {
            onTap(audioQuiz) // Call the closure to navigate to QuizInfoView
        }
    }
}

