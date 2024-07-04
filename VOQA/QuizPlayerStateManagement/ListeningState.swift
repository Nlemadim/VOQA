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
import AVFoundation

class ListeningState: StateObserver, QuizState {
    
    enum ListenerAction {
        case prepareToTranscribe
        case prepareMicrophone
        case transcribe
        case doneTranscribing
        case proceedWithQuiz
    }
    
    enum MicBeeper {
        case micOn
        case micOff
    }
    
    @Published var isRecordingAnswer: Bool = false
    @Published var selectedOption: String = ""
    @Published var userTranscript: String = ""
    
    private var cancellable: AnyCancellable?
    var speechRecognizer = SpeechManager()
    private var audioPlayer: AVAudioPlayer?
    var context: QuizContext?
    var observers: [StateObserver] = []
    private var action: ListenerAction?
    var beeper: MicBeeper?

    init(action: ListenerAction? = nil) {
        print("Listener Initialized")
        self.action = action
    }

    func handleState(context: QuizContext) {
        if let action = self.action {
            self.performAction(action, context: context)
        }
    }
    
    func performAction(_ action: ListenerAction, context: QuizContext) {
        print("Listener performAction called with action: \(action)")
        
        switch action {
    
        case .prepareMicrophone:
            print("Action: prepareMicrophone")
            
            self.speechRecognizer.prepareMicrophone()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                context.isListening = true
                self.performAction(.transcribe, context: context)
            }
            
        case .transcribe:
            print("Action: Transcribing")
            
            self.startRecordingAndTranscribing(context: context)
            
        case .doneTranscribing:
            print("Action: doneTranscribing")
            
            speechRecognizer.stopTranscribing()
            
            context.setState(context.presenter)
            
            context.presenter.performAction(.dismissMic, context: context)
            
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.performAction(.proceedWithQuiz, context: context)
//                print("Context spokenAnswerOption set to \(context.spokenAnswerOption)")
//                print("Context isListening set to \(context.isListening)")
//            }
            
//        case .proceedWithQuiz:
//            print("Listener Sign off - Setting state to existing QuizModerator with action .validateSpokenResponse")
//            
//            context.quizModerator.action = .validateSpokenResponse
//            context.setState(context.quizModerator)
            
        default:
            break
        }
    }

    private func startRecordingAndTranscribing(context: QuizContext) {
        print("Starting transcription...")
        
        self.isRecordingAnswer = true
        print("Context isListening set to \(context.isListening)")
        print("isRecordingAnswer set to \(self.isRecordingAnswer)")
        
        self.speechRecognizer.transcribe()
        print("Transcribing started")
        print("Speech Recongnizer mic is ready: \(speechRecognizer.isMicrophoneReady)")
        DispatchQueue.main.asyncAfter(deadline: .now() + context.responseTime + 0.8) {
            print("Transcription stopping...")
            self.speechRecognizer.stopTranscribing()
            self.isRecordingAnswer = false
            context.isListening = false
            print("Transcription stopped")
            
            print("isRecordingAnswer set to \(self.isRecordingAnswer)")
            
            self.getTranscript(context: context)
            
            self.performAction(.doneTranscribing, context: context)
        }
    }

    private func getTranscript(context: QuizContext) {
        print("Getting transcript...")
        cancellable = speechRecognizer.$transcript
            .sink { newTranscript in
                print("Received new transcript: \(newTranscript)")
                
                self.selectedOption = self.processTranscript(transcript: newTranscript)
                
                print("Processed transcript to selectedOption: \(self.selectedOption)")
                context.spokenAnswerOption = self.selectedOption
                print("Context spokenAnswerOption set to \(context.spokenAnswerOption)")

                // Capture message passed to moderator
                print("Message to Moderator: \(context.spokenAnswerOption)")
            }
    }

    private func processTranscript(transcript: String) -> String {
        let processedTranscript = WordProcessor.processWords(from: transcript)
        return processedTranscript
    }
    
    func stateDidChange(to newState: any QuizState) {
        print("Listener state did change to \(type(of: newState))")
        // Handle state-specific updates if needed
    }
    
    func addObserver(_ observer: StateObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.stateDidChange(to: self)
        }
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
