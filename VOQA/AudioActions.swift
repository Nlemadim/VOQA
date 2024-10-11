//
//  AudioActions.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import Foundation

enum AudioAction: Equatable {
    case playCorrectAnswerCallout
    case playWrongAnswerCallout
    case playNoResponseCallout
    case waitingForResponse
    case receivedResponse
    case playQuestionAudioUrl(url: String)
    case playAnswer(url: String)
    case playFeedbackMessage(url: String)
    case giveScore(score: Int)
    case nextQuestion
    case prepareReview
    case sponsoredOutro
    case dynamicReview(url: String)
    case pausePlay
    case reset
    case playBGM
    case playHostIntro
    case playClosingRemarks
    case playSessionIntro
    

    static func ==(lhs: AudioAction, rhs: AudioAction) -> Bool {
        switch (lhs, rhs) {
        case (.playCorrectAnswerCallout, .playCorrectAnswerCallout),
             (.playWrongAnswerCallout, .playWrongAnswerCallout),
             (.playNoResponseCallout, .playNoResponseCallout),
             (.waitingForResponse, .waitingForResponse),
             (.receivedResponse, .receivedResponse),
             (.nextQuestion, .nextQuestion),
             (.prepareReview, .prepareReview),
             (.sponsoredOutro, .sponsoredOutro),
             (.pausePlay, .pausePlay),
             (.reset, .reset),
             (.playHostIntro, .playHostIntro),
             (.playClosingRemarks, .playClosingRemarks),
             (.playSessionIntro, .playSessionIntro):
            return true
            
        case (.playQuestionAudioUrl(let lhsUrl), .playQuestionAudioUrl(let rhsUrl)),
             (.playAnswer(let lhsUrl), .playAnswer(let rhsUrl)),
             (.dynamicReview(let lhsUrl), .dynamicReview(let rhsUrl)),
             (.playFeedbackMessage(let lhsUrl), .playFeedbackMessage(let rhsUrl)):
            return lhsUrl == rhsUrl
            
        case (.giveScore(let lhsScore), .giveScore(let rhsScore)):
            return lhsScore == rhsScore
            
        default:
            return false
        }
    }

    var description: String {
        switch self {
        case .playQuestionAudioUrl(_):
            return "Playing Question"
        case .playAnswer(let url):
            return "Play Answer URL: \(url)"
        case .playFeedbackMessage(_):
            return "Playing Feedback"
        case .giveScore(_):
            return "Your Score"
        case .playCorrectAnswerCallout:
            return "Correct!"
        case .playWrongAnswerCallout:
            return "Wrong Answer."
        case .playNoResponseCallout:
            return "No Response?"
        case .waitingForResponse:
            return "Waiting For Response..."
        case .receivedResponse:
            return "Received Response!"
        case .nextQuestion:
            return "Next Question..."
        case .dynamicReview:
            return "Reviewing your performance."
        case .pausePlay:
            return "Paused Play"
        case .reset:
            return "Ok Bye!"
        case .playBGM:
            return "Background Music"
        case .playHostIntro:
            return "Meet the Host!"
        case .playSessionIntro:
            return "About This Quiz!"
        case .prepareReview:
            return "Getting Your Review!"
        case .sponsoredOutro:
            return "Sponsored Message"
        case .playClosingRemarks:
            return "Thanks for joining us!"
        }
    }
}

enum MusicStyle {
    case intro
    case outro
    case winningStreak
    
    var duration: TimeInterval {
        switch self {
        case .intro:
            return 25.0
        case .outro:
            return 30.0
        case .winningStreak:
            return 15.0
        }
    }
}

