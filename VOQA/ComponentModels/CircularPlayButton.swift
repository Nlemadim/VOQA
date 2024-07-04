//
//  CircularPlayButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI

struct CircularPlayButton: View {
    @ObservedObject var quizContext: QuizSession
    @Binding var isDownloading: Bool
    var imageLabel: String?
    var color: Color
    var playAction: () -> Void
    
    var body: some View {
        Button(action: {
            playAction()
        }) {
            if isDownloading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Image(systemName: quizContext.isNowPlaying == true ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22.5, height: 22.5)
            }
        }
        .frame(width: 50, height: 50)
        .background(color)
        .foregroundColor(color.dynamicTextColor())
        .activeGlow(color.dynamicTextColor(), radius: 1)
        .cornerRadius(25)
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 1)
        )
        .disabled(isDownloading)
        .accessibilityLabel(imageLabel ?? (quizContext.isNowPlaying == true ? "Pause" : "Play"))
        .accessibilityHint(isDownloading ? "Downloading..." : (quizContext.isNowPlaying == true ? "Tap to pause" : "Tap to play"))
    }
}

//CircularPlayButton(
//    quizContext: MockQuizContext(),
//    isDownloading: .constant(false),
//    imageLabel: "Play Button",
//    color: .blue) {
//        print("Play action")
//    }
