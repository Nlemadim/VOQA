//
//  Reviews.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation

/// State representing the review state of the quiz.
class ReviewState: BaseState {
    enum ReviewAction {
        case reviewing
        case doneReviewing
    }
    
    var action: ReviewAction
    
    init(action: ReviewAction) {
        self.action = action
    }
    
    override func handleState(context: QuizContext) {
        switch action {
        case .reviewing:
            // Play review feedback message
            context.audioPlayer?.playReviewAudio(["review_message.mp3"])
        case .doneReviewing:
            // Transition to EndedQuizState
            context.setState(EndedQuizState())
        }
        notifyObservers()
    }
}
