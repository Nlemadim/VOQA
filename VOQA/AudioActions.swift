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
    case nextQuestion
    case reviewing
    case pausePlay
    case reset

    static func ==(lhs: AudioAction, rhs: AudioAction) -> Bool {
        switch (lhs, rhs) {
        case (.playCorrectAnswerCallout, .playCorrectAnswerCallout),
             (.playWrongAnswerCallout, .playWrongAnswerCallout),
             (.playNoResponseCallout, .playNoResponseCallout),
             (.waitingForResponse, .waitingForResponse),
             (.receivedResponse, .receivedResponse),
             (.nextQuestion, .nextQuestion),
             (.reviewing, .reviewing),
             (.pausePlay, .pausePlay),
             (.reset, .reset):
            return true
        case (.playQuestionAudioUrl(let lhsUrl), .playQuestionAudioUrl(let rhsUrl)),
             (.playAnswer(let lhsUrl), .playAnswer(let rhsUrl)),
             (.playFeedbackMessage(let lhsUrl), .playFeedbackMessage(let rhsUrl)):
            return lhsUrl == rhsUrl
        default:
            return false
        }
    }

    var description: String {
        switch self {
        case .playCorrectAnswerCallout:
            return "Play Correct Answer Callout"
        case .playWrongAnswerCallout:
            return "Play Wrong Answer Callout"
        case .playNoResponseCallout:
            return "Play No Response Callout"
        case .waitingForResponse:
            return "Waiting For Response"
        case .receivedResponse:
            return "Received Response"
        case .playQuestionAudioUrl(let url):
            return "Play Question Audio URL: \(url)"
        case .playAnswer(let url):
            return "Play Answer URL: \(url)"
        case .playFeedbackMessage(let url):
            return "Play Feedback Message URL: \(url)"
        case .nextQuestion:
            return "Next Question"
        case .reviewing:
            return "Reviewing"
        case .pausePlay:
            return "Pause Play"
        case .reset:
            return "Reset"
        }
    }
}

