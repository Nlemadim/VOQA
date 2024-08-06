//
//  FormattedQuestionContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

struct FormattedQuestionContentView: View {
    var questionTranscript: String
    var body: some View {
        VStack {
            Text(questionTranscript)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .kerning(0.5)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .padding(.horizontal)
    }
}

struct FormattedCountDownTextView: View {
    var countdownTimerText: String
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(countdownTimerText)
                .font(.largeTitle)
                .fontWeight(.black)
                .padding()
                .padding(.horizontal)
                .padding(.bottom)
            Spacer()
            Text("Get Ready!")
                .fontWeight(.light)
                .frame(alignment: .center)
                .padding()
                .padding(.horizontal)
        }
    }
}

struct RateQuizView: View {
    @Binding var currentRating: Int?
    var body: some View {
        VStack {
            Text("Rate This Quiz")
                .font(.system(size: 8))
                .foregroundStyle(.secondary)
            RatingsView(
                maxRating: 4,
                currentRating: $currentRating,
                width: 30,
                color: .systemTeal,
                sfSymbol: "star"
            )
        }
    }
}






