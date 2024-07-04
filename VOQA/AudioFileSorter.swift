//
//  AudioFileSorter.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/29/24.
//

import Foundation


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
    
}
