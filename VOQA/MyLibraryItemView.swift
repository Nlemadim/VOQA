//
//  MyLibraryItemView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/24/24.
//

import Foundation
import SwiftUI

struct LibraryListView: View {
    var voqaCollection: [Voqa]
    var onSelectVoqa: (Voqa) -> Void

    var body: some View {
        List {
            ForEach(voqaCollection, id: \.self) { voqa in
                MyLibraryItemView(audioQuiz: voqa) { voqa in 
                    onSelectVoqa(voqa)
                }
            }
        }
    }
}

struct MyLibraryItemView: View {
    @EnvironmentObject var user: User
    var audioQuiz: Voqa
    var onTap: (Voqa) -> Void

    var body: some View {
        Button(action: {
            onTap(audioQuiz)
        }, label: {
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
            }
        })
    }
}


