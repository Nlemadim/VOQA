//
//  QuestionDetailView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI
import AVKit
import Speech

struct QuestionDetailView: View {
    @State private var showSiriAlert = false
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?

    @StateObject private var quizContext: QuizContext

    init(questions: [Question]) {
        let context = QuizContext(state: IdleState())
        let audioPlayer = AudioContentPlayer(context: context)
        let quizModerator = QuizModerator(context: context)
        context.audioPlayer = audioPlayer
        context.quizModerator = quizModerator
        _quizContext = StateObject(wrappedValue: context)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(quizContext.audioPlayer?.currentQuestionContent ?? "")
                .font(.title2)
                .padding()
            Text(quizContext.audioPlayer?.hasNextQuestion ?? false ? "\(quizContext.audioPlayer?.currentQuestionIndex ?? 0 + 1)" : "QUIZ COMPLETE!")
                .padding(.horizontal)
            Text("\(quizContext.audioPlayer?.currentPlaybackPower ?? 0.0)")
                .padding(.horizontal)

            Spacer()

            if quizContext.countdownTime > 0 {
                Text("Get Ready: \(quizContext.countdownTime)")
                    .font(.title)
                    .padding()
                    .opacity(quizContext.countdownTime > 0 ? 1 : 0)
            }

            HStack(spacing: 20) {
                Button(action: {
                    if isPlaying {
                        quizContext.audioPlayer?.pausePlayback()
                        isPlaying = false
                    } else {
                        quizContext.audioPlayer?.playQuestions(sampleQuestions)
                        isPlaying = true
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.green))
                        .foregroundColor(.white)
                }
                .alert(isPresented: $showSiriAlert) {
                    Alert(title: Text("Missing Audio"), message: Text("Would you like to read the question with Siri?"), primaryButton: .default(Text("Yes")) {
                        quizContext.audioPlayer?.playWithSiri(sampleQuestions.first!.audioScript)
                    }, secondaryButton: .cancel())
                }

                Button(action: {
                    quizContext.audioPlayer?.skipToQuestion(withId: sampleQuestions.first!.id)
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.red))
                        .foregroundColor(.white)
                }

                Button(action: {
                    quizContext.audioPlayer?.playMultiAudioFiles(mainFile: "VoiceOverSimulation.mp3", bgmFile: "VoqaBgm.mp3")
                }) {
                    Image(systemName: "music.note")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .foregroundColor(.white)
                }

                Button(action: {
                    quizContext.audioPlayer?.stopAndResetPlayer()
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 10)
            
            
            Button(action: {
                
                if let player = quizContext.audioPlayer {
                    DispatchQueue.main.async {
                        player.questions = sampleQuestions
                        quizContext.startQuiz()
                    }
                } else {
                    print("Error on start")
                }
               
            }) {
                Image(systemName: "stop.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding()
                    .background(Circle().fill(Color.blue))
                    .foregroundColor(.white)
            }
        }
        
        .sheet(isPresented: $quizContext.isListening) {
            VStack {
                Text("Listening...")
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .padding(.bottom, 20)
            }
            .presentationDetents([.medium])
            .frame(height: 120)
//            .onAppear {
//                showMicAlertBell()
//            }
//            .onDisappear(perform: {
//                dismissResponderBell()
//            })
        }
    }
    
    private func showMicAlertBell() {
        let audioSession = AVAudioSession.sharedInstance()
        if let path = Bundle.main.path(forResource: "showResponderBell", ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            
            do {
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
                
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
    
    private func dismissResponderBell() {
        let audioSession = AVAudioSession.sharedInstance()
        if let path = Bundle.main.path(forResource: "dismissResponderBell", ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            
            do {
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
                
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
}

let sampleQuestions: [Question] = [
    Question(id: UUID(), topicId: UUID(), content: "What is the capital of France?", options: ["Paris", "London", "Berlin", "Madrid"], correctOption: "A", audioScript: "New Question, what is the capital of France.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the capital of France.", replayOptionAudioScript: "Options are: Paris, London, Berlin, Madrid"),
    Question(id: UUID(), topicId: UUID(), content: "What is the currency of Japan?", options: ["Yen", "Dollar", "Euro", "Pound"], correctOption: "A", audioScript: "New Question, what is the currency of Japan.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the currency of Japan.", replayOptionAudioScript: "Options are: Yen, Dollar, Euro, Pound"),
    Question(id: UUID(), topicId: UUID(), content: "Who is the current President of the USA?", options: ["Joe Biden", "Donald Trump", "Barack Obama", "George Bush"], correctOption: "A", audioScript: "New Question, who is the current President of the USA.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, who is the current President of the USA.", replayOptionAudioScript: "Options are: Joe Biden, Donald Trump, Barack Obama, George Bush"),
    Question(id: UUID(), topicId: UUID(), content: "What is the tallest mountain in the world?", options: ["Mount Everest", "K2", "Kangchenjunga", "Lhotse"], correctOption: "A", audioScript: "New Question, what is the tallest mountain in the world.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the tallest mountain in the world.", replayOptionAudioScript: "Options are: Mount Everest, K2, Kangchenjunga, Lhotse"),
    Question(id: UUID(), topicId: UUID(), content: "What is the chemical symbol for water?", options: ["H2O", "O2", "CO2", "H2"], correctOption: "A", audioScript: "New Question, what is the chemical symbol for water.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the chemical symbol for water.", replayOptionAudioScript: "Options are: H2O, O2, CO2, H2")
]


#Preview {
    QuestionDetailView(questions: sampleQuestions)
}
