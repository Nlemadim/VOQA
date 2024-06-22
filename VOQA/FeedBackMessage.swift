//
//  FeedBackMessage.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation

/// State representing the feedback message state of the quiz.
class FeedbackMessageState: BaseState {
    enum FeedbackType {
        case correctAnswer
        case incorrectAnswer
        case noResponse
        case transcriptionError
    }
    
    var type: FeedbackType
    
    init(type: FeedbackType) {
        self.type = type
    }
    
    override func handleState(context: QuizContext) {
        switch type {
        case .correctAnswer:
            // Handle playing correct answer feedback message logic
            playFeedbackAudio(context, fileName: "correctAnswerBell.wav")
        case .incorrectAnswer:
            // Handle playing incorrect answer feedback message logic
            playFeedbackAudio(context, fileName: "wrongAnswerBell.wav")
        case .noResponse:
            // Handle playing no response feedback message logic
            playFeedbackAudio(context, fileName: "errorBell.wav")
        case .transcriptionError:
            // Handle playing transcription error feedback message logic
            playFeedbackAudio(context, fileName: "transcription_error.mp3")
        }
        notifyObservers()
    }
    
    private func playFeedbackAudio(_ context: QuizContext, fileName: String) {
        context.audioPlayer?.playFeedbackAudio(type: type, audioFile: fileName)
    }
}
