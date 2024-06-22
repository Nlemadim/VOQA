//
//  ListeningState.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/21/24.
//

import Foundation
import SwiftUI
import Speech
import Combine

class ListeningState: BaseState {
    @Published var isRecordingAnswer: Bool = false
    @Published var selectedOption: String = ""
    @Published var userTranscript: String = ""
    
    private var cancellable: AnyCancellable?
    private var speechRecognizer = SpeechManager()
    
    override func handleState(context: QuizContext) {
        recordAnswer(context: context)
        notifyObservers()
    }
    
    private func recordAnswer(context: QuizContext) {
        startRecordingAndTranscribing(context: context)
    }
    
    private func startRecordingAndTranscribing(context: QuizContext) {
        print("Starting transcription...")
        self.isRecordingAnswer = true
        context.isListening = true
        
        self.speechRecognizer.transcribe()
        print("Transcribing started")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + context.responseTime) {
            self.speechRecognizer.stopTranscribing()
            self.isRecordingAnswer = false
            context.isListening = false
            print("Transcription stopped")
            
            self.getTranscript(context: context)
        }
    }
    
    private func getTranscript(context: QuizContext) {
        cancellable = speechRecognizer.$transcript
            .sink { newTranscript in
                self.selectedOption = self.processTranscript(transcript: newTranscript)
                self.userTranscript = newTranscript
                self.forwardResponse(context: context, response: self.selectedOption)
            }
    }
    
    private func processTranscript(transcript: String) -> String {
        let processedTranscript = WordProcessor.processWords(from: transcript)
        return processedTranscript
    }
    
    private func forwardResponse(context: QuizContext, response: String) {
        print("Forwarding response: \(response)")
        if let currentQuestion = context.audioPlayer?.questions[context.audioPlayer?.currentQuestionIndex ?? 0] {
            context.quizModerator?.validateResponse(response, for: currentQuestion.id)
        }
    }
}



/// State representing the started quiz state of the quiz.
class StartedQuizState: BaseState {
    override func handleState(context: QuizContext) {
        // Handle started quiz logic
        notifyObservers()
    }
}

/// State representing the started quiz state of the quiz.
class EndedQuizState: BaseState {
    override func handleState(context: QuizContext) {
        context.activeQuiz = false
        // Handle any additional logic for ending the quiz, such as reloading questions for future implementation
        notifyObservers()
    }
}

///// State representing the countdown state of the quiz.
//class CountdownState: BaseState {
//    enum CountdownType {
//        case quizStart
//        case responseTimer
//    }
//    
//    var type: CountdownType
//    
//    init(type: CountdownType) {
//        self.type = type
//    }
//    
//    override func handleState(context: QuizContext) {
//        switch type {
//        case .quizStart:
//            // Handle quiz start countdown logic
//            break
//        case .responseTimer:
//            // Handle response timer countdown logic
//            break
//        }
//        notifyObservers()
//    }
//}
