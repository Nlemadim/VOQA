//
//  ReviewState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
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
        print("Review State initialized")
    }
    
    override func handleState(context: QuizContext) {
        switch action {
        case .reviewing:
            // Play review feedback message
            context.currentQuestionText = "Reviewing"     
            context.setState(ReviewState(action: .doneReviewing))
            //context.questionPlayer.playReviewAudio(["NextQuestionWave"])
        case .doneReviewing:
            // Transition to EndedQuizState
            context.setState(EndedQuizState())
        }
        notifyObservers()
    }
}
