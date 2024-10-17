//
//  PlaylistRowView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/16/24.
//

import Foundation
import SwiftUI

struct PlaylistRowView: View {
    let playlist: Playlist
    let isLoadingQuiz: Bool?
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Cached image with play/lock overlay
            ZStack {
                CachedImageView(imageUrl: playlist.imageUrl)
                    .frame(width: 120, height: 120)
                    .cornerRadius(10)
                    .accessibilityLabel(Text("Playlist Icon: \(playlist.quizTitle)"))
                    .overlay(
                        VStack {
                            Spacer()
                            if isLoadingQuiz ?? false {
                                ProgressView()
                                    .frame(width: 30, height: 30)
                                    .padding(8)
                            } else {
                                Button(action: {
                                    action()
                                }) {
                                    if !playlist.isUnlocked {
                                        Image(systemName: "lock.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.gray)
                                            .padding(8)
                                    } else {
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.primary)
                                            .padding(8)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(isLoadingQuiz ?? false)
                            }
                            Spacer()
                        }
                    )
            }
            
            // Playlist text next to the image
            VStack(alignment: .leading, spacing: 4) {
                Text(playlist.quizTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let description = playlist.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if !playlist.isUnlocked {
                    Text(playlist.unlockCondition)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

