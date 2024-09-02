//
//  ImageAndTitleView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI
import Shimmer

struct ImageAndTitleView: View {
    var title: String
    var imageUrl: String
    let tapAction: (Voqa) -> Void
    var quiz: Voqa

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedImageView(imageUrl: imageUrl)
                .frame(width: 170, height: 200)
                .cornerRadius(10.0)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: 13))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                    
                } else {
                  
                    Text("Loading title...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .redacted(reason: .placeholder)
                        .shimmering(active: true)
                }

                Text("\(quiz.users) Ratings")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)

                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= quiz.rating ? "star.fill" : "star")
                            .imageScale(.small)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(RoundedRectangle(cornerRadius: 15.0).fill(Material.ultraThick).tint(.white).activeGlow(.white, radius: 2))
        .padding(10)
        .padding(.bottom, 20)
        .onTapGesture {
            tapAction(quiz)
        }
    }
}
