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
                //.fontWeight(.light)
                .multilineTextAlignment(.center)
                .kerning(0.5)
                .frame(maxWidth: .infinity, alignment: .center)
                
        }
        .padding()
        .padding(.horizontal)
    }
}

struct FormattedCountDownTextView: View {
    var countdownTimer: String
    var body: some View {
        VStack(spacing: 8) {
            Text(countdownTimer)
                .font(.largeTitle)
                .fontWeight(.black)
                .frame(alignment: .center)
                .padding()
                .padding(.horizontal)
                .padding(.bottom)
            
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






