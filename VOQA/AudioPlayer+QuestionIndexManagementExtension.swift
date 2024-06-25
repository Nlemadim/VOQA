//
//  AudioPlayer+QuestionIndexManagementExtension.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation

extension AudioContentPlayer {
    // MARK: - Question Index Management
    internal func saveCurrentQuestionIndex() {
        UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
    }

    internal func loadCurrentQuestionIndex() {
        currentQuestionIndex = UserDefaults.standard.integer(forKey: "currentQuestionIndex")
        updateHasNextQuestion()
    }
    
    func updateHasNextQuestion() {
        hasNextQuestion = currentQuestionIndex + 1 < questions.count
    }
}
