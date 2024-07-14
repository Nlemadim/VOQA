//
//  EnvironmentVariables.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/13/24.
//

import Foundation
import SwiftUI

struct QuizSessionConfigKey: EnvironmentKey {
    static let defaultValue: QuizSessionConfig? = nil
}

struct QuestionsKey: EnvironmentKey {
    static let defaultValue: [Question] = []
}

extension EnvironmentValues {
    var questions: [Question] {
        get { self[QuestionsKey.self] }
        set { self[QuestionsKey.self] = newValue }
    }
}

extension EnvironmentValues {
    var quizSessionConfig: QuizSessionConfig? {
        get { self[QuizSessionConfigKey.self] }
        set { self[QuizSessionConfigKey.self] = newValue }
    }
}
