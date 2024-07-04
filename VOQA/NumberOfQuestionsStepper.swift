//
//  NumberOfQuestionsStepper.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct NumberOfQuestionsStepper: View {
    @Binding var numberOfQuestions: Int

    var body: some View {
        VStack {
            Stepper(value: $numberOfQuestions, in: 10...50, step: 5) {
                Text("\(numberOfQuestions) Questions")
                    .font(.subheadline)
            }
            .onChange(of: numberOfQuestions) {_, newValue in
                UserDefaultsManager.setDefaultNumberOfTestQuestions(newValue)
            }
        }
    }
}


#Preview {
    NumberOfQuestionsStepper(numberOfQuestions: .constant(10))
}
