//
//  LatestScore.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import Foundation

struct LatestScore1 {
    var quizId: String
    var date: Date
    var quizCategory: String
    var numberOfquestions: String
    var review: String
    var score: String
}

extension LatestScore1 {
    /// Initializes a `LatestScore1` instance from a `Performance` instance if the performance date is more recent.
    ///
    /// - Parameters:
    ///   - performance: The `Performance` instance to initialize from.
    ///   - currentLatestScore: The existing `LatestScore1` instance to compare dates with.
    /// - Returns: A new `LatestScore1` instance if the performance date is more recent, otherwise `nil`.
    init?(performance: Performance, currentLatestScore: LatestScore1) {
        // Check if the performance date is more recent than the current latest score's date
        guard performance.date > currentLatestScore.date else {
            return nil // Return nil if the performance date is not more recent
        }
        
        // Initialize LatestScore1 with performance data if the date is more recent
        self.quizId = performance.quizId ?? ""
        self.date = performance.date
        self.quizCategory = performance.quizCategory ?? "Unknown" // Use quizCategory if available
        self.numberOfquestions = "\(performance.numberOfQuestions)"
        self.review = "Performance review is not available."
        self.score = "\(performance.score)%"
    }
}

