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

struct PerformanceKey: EnvironmentKey {
    static let defaultValue: [Performance] = []
}

extension EnvironmentValues {
    var questions: [Question] {
        get { self[QuestionsKey.self] }
        set { self[QuestionsKey.self] = newValue }
    }
    
    var quizSessionConfig: QuizSessionConfig? {
        get { self[QuizSessionConfigKey.self] }
        set { self[QuizSessionConfigKey.self] = newValue }
    }
    
    var userPerformance: [Performance] {
        get { self[PerformanceKey.self] }
        set { self[PerformanceKey.self] = newValue }
    }
}



