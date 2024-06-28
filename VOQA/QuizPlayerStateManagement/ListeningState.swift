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
        
        playListeningSound()
        if let action = self.action {
            self.speechRecognizer.prepareMicrophone()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.performAction(action, context: context)
            }
        }
    }
    
    private func performAction(_ action: ListenerAction, context: QuizContext) {
        switch action {
        case .prepareToTranscribe:
            print(action)
            
            self.startRecordingAndTranscribing(context: context)
            
        case.doneTranscribing:
            print(action)
            playCloseMicSound()
            print("Listener Sign off")
            context.setState(QuizModerator(action: .validateSpokenResponse))
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
        
        
        self.speechRecognizer.transcribe()
        print("Transcribing started")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + context.responseTime + 0.8) {
            self.speechRecognizer.stopTranscribing()
            self.isRecordingAnswer = false
            context.isListening = false
            
            print("Transcription stopped")
            
            self.getTranscript(context: context)
            self.performAction(.doneTranscribing, context: context)
        }
    }
    
    private func getTranscript(context: QuizContext) {
        cancellable = speechRecognizer.$transcript
            .sink { newTranscript in
                self.selectedOption = self.processTranscript(transcript: newTranscript)
                context.spokenAnswerOption = self.selectedOption
            }

    }
    
    private func presentMic() {
        
        cancellable = speechRecognizer.$isMicrophoneReady
            .sink(receiveValue: { isReady in
                if isReady {
                    print("Listener Mic Ready")
                    if let context = self.context {
                        self.startRecordingAndTranscribing(context: context)
                    }
                }
            })
    }
    
    
    private func processTranscript(transcript: String) -> String {
        let processedTranscript = WordProcessor.processWords(from: transcript)
        return processedTranscript
    }
    
    func stateDidChange(to newState: any QuizState) {
        
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
