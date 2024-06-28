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
    var feedbackMessages: [VoiceFeedbackMessages] = []
    
    init(type: FeedbackType) {
        self.type = type
        print("Feedback Player Initialized")
    }
    
    override func handleState(context: QuizContext) {
        switch type {
        case .correctAnswer:
            // Handle playing correct answer feedback message logic
            playFeedbackAudio(context, fileName: "NextQuestionWave.wav")
            
        case .incorrectAnswer:
            // Handle playing incorrect answer feedback message logic
            playFeedbackAudio(context, fileName: "showResponderBell.wav")
        case .noResponse:
            print("No response")
            // Handle playing no response feedback message logic
            playFeedbackAudio(context, fileName: "dismissResponderBell.wav")
        case .transcriptionError:
            print("Transcription Error")
            // Handle playing transcription error feedback message logic
            playFeedbackAudio(context, fileName: "errorBell.mp3")
        }
        notifyObservers()
    }
    
    //func setUpVoiceFeedbackMessages()
    
    
    private func playFeedbackAudio(_ context: QuizContext, fileName: String) {
        //context.audioPlayer?.playFeedbackAudio(type: type, audioFile: fileName)
    }
}
