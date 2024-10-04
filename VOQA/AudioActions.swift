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
    case reviewing
    case pausePlay
    case reset
    case playBGM
    case playHostIntro
    
    //Updated Action
    case playSessionIntro
    

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
             (.reset, .reset),
             (.playHostIntro, .playHostIntro),
             (.playSessionIntro, .playSessionIntro):
            return true
            
        case (.playQuestionAudioUrl(let lhsUrl), .playQuestionAudioUrl(let rhsUrl)),
             (.playAnswer(let lhsUrl), .playAnswer(let rhsUrl)),
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
            return "Playing Correct Answer Callout"
        case .playWrongAnswerCallout:
            return "Play Wrong Answer Callout"
        case .playNoResponseCallout:
            return "Play No Response Callout"
        case .waitingForResponse:
            return "Waiting For Response"
        case .receivedResponse:
            return "Received Response"
        case .nextQuestion:
            return "Next Question"
        case .reviewing:
            return "Reviewing"
        case .pausePlay:
            return "Pause Play"
        case .reset:
            return "Reset"
        case .playBGM:
            return "Background Music"
        case .playHostIntro:
            return "Meet the Host!"
        case .playSessionIntro:
            return "About This Quiz"
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

