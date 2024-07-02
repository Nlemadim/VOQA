//
//  AudioFileSorter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/29/24.
//

import Foundation

enum AudioAction {
    case playCorrectAnswerCallout
    case playWrongAnswerCallout
    case playNoResponseCallout
    case playMicBeeper(Beeper)
    case playQuestion(url: String)
    case playAnswer(url: String)
    case nextQuestion
    case reviewing
    
}

typealias Beeper = ListeningState.MicBeeper

class AudioFileSorter {
    static func getAudioAction(for state: QuizState, context: QuizContext) -> AudioAction? {
        switch state {
        case let listenerState as ListeningState:
            return getAudioActionForListeningState(listenerState: listenerState)
            
        case let moderator as QuizModerator:
            return getAudioActionForModerator(moderator: moderator)
            
        default:
            return nil
        }
    }
    
    private static func getAudioActionForListeningState(listenerState: ListeningState) -> AudioAction? {
        guard let beeper = listenerState.beeper else { return nil }
        return .playMicBeeper(beeper)
    }
    
    private static func getAudioActionForModerator(moderator: QuizModerator) -> AudioAction? {
        guard let feedback = moderator.validationFeedback else { return nil }
        
        switch feedback {
        case .noResponseFeedback:
            return .playNoResponseCallout
        case .correctAnswerFeedback:
            return .playCorrectAnswerCallout
        case .incorrectAnswerFeedback:
            return .playWrongAnswerCallout
        case .noFeedback:
            return nil
        case .goToNextQuestion:
            return .nextQuestion
            
        }
    }
    
    private static func getAudioActionForPresenter(presenter: QuizPresenter) -> AudioAction? {
        guard let presentation = presenter.action else { return nil }
        
        switch presentation {
            
        case .presentQuestion(let questionUrl):
            return .playQuestion(url: questionUrl)
            
        case .presentAnswer(let answerUrl):
            return .playAnswer(url: answerUrl)
            
        case .presentMic(let beeper):
            return .playMicBeeper(beeper)
            
        case .dismissMic(_):
            return .playMicBeeper(.micOff)
            
        default:
            break
        }
        
        return nil
    }
}
