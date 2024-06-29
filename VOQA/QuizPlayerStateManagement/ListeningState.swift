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
        case doneTranscribing
    }
    
    @Published var isRecordingAnswer: Bool = false
    @Published var selectedOption: String = ""
    @Published var userTranscript: String = ""
    
    private var cancellable: AnyCancellable?
    var speechRecognizer = SpeechManager()
    private var audioPlayer: AVAudioPlayer?
    private var context: QuizContext?
    var observers: [StateObserver] = []
    private var action: ListenerAction?

    init(action: ListenerAction? = nil) {
        print("Listener Initialized")
        self.action = action
    }

    func handleState(context: QuizContext) {
        if let action = self.action {
            self.speechRecognizer.prepareMicrophone()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.performAction(action, context: context)
            }
        }
    }
    
    private func performAction(_ action: ListenerAction, context: QuizContext) {
        print("Listener performAction called with action: \(action)")
        
        switch action {
        case .prepareToTranscribe:
            //playListeningSound()
            print("Action: prepareToTranscribe")
            self.speechRecognizer.prepareMicrophone()
            self.startRecordingAndTranscribing(context: context)
            
        case .doneTranscribing:
            print("Action: doneTranscribing")
            playCloseMicSound()
            print("Listener Sign off - Setting state to existing QuizModerator with action .validateSpokenResponse")
            context.quizModerator.action = .validateSpokenResponse
            context.setState(context.quizModerator)
        }
    }

    
    private func playListeningSound() {
        print("Mic Beeper!")
        playSound(fileName: "showResponderBell", fileType: "wav")
    }
    
    private func playCloseMicSound() {
        print("Mic Closer!")
        playSound(fileName: "dismissResponderBell", fileType: "wav")
    }
    
    private func playSound(fileName: String, fileType: String) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
                let url = URL(fileURLWithPath: path)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } else {
                print("Sound file not found: \(fileName).\(fileType)")
            }
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    private func startRecordingAndTranscribing(context: QuizContext) {
        print("Starting transcription...")
        context.isListening = true
        self.isRecordingAnswer = true
        print("Context isListening set to \(context.isListening)")
        print("isRecordingAnswer set to \(self.isRecordingAnswer)")
        
        self.speechRecognizer.transcribe()
        print("Transcribing started")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + context.responseTime + 0.8) {
            print("Transcription stopping...")
            self.speechRecognizer.stopTranscribing()
            self.isRecordingAnswer = false
            context.isListening = false
            print("Transcription stopped")
            print("Context isListening set to \(context.isListening)")
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
    
    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Listener has sounded mic alert")
            DispatchQueue.main.async {
                player.stop()
                player.delegate = nil
                self.audioPlayer = nil

            }
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
