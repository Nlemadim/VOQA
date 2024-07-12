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
        Text(questionTranscript)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .kerning(1.5)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }
}
