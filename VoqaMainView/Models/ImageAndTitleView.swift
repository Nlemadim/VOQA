//
//  ImageAndTitleView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

struct ImageAndTitleView: View {
    var title: String
    var titleImage: String
    let tapAction: (Voqa) -> Void
    var quiz: Voqa

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let url = URL(string: titleImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 170, height: 200)
                            .cornerRadius(10.0)
                            .clipped()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 170, height: 200)
                            .cornerRadius(10.0)
                            .clipped()
                    case .failure:
                        ProgressView()
                            .frame(width: 170, height: 200)
                            .cornerRadius(10.0)
                            .clipped()
                    @unknown default:
                        ProgressView()
                            .frame(width: 170, height: 200)
                            .cornerRadius(10.0)
                            .clipped()
                    }
                }
            } else {
                ProgressView()
                    .frame(width: 170, height: 200)
                    .cornerRadius(10.0)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.bold)
            
                    Text("\(quiz.users) users")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            if index <= quiz.rating {
                                Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom)
                
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(RoundedRectangle(cornerRadius: 15.0).fill(Material.ultraThin).tint(.white).activeGlow(.white, radius: 2))
        .padding(10)
        .padding(.bottom, 20)
        .onTapGesture {
            tapAction(quiz)
        }
    }
}


