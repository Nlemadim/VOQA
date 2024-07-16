//
//  QuizContextModuleTest.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/2/24.
//

import SwiftUI
import Combine

struct TestConfigView: View {
    let config: QuizSessionConfig
    @StateObject private var viewModel: QuizViewModel
    @State private var audioPlayer: SessionAudioPlayer?
    @State private var cancellables: Set<AnyCancellable> = []

    init(config: QuizSessionConfig) {
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
        self.config = config
    }

    var body: some View {
        VStack {
            Text("Test Audio File Sorter Actions")
                .font(.largeTitle)
                .padding()

            Button(action: {
                playAudioAction(.playCorrectAnswerCallout)
            }) {
                Text("Play Correct Answer Callout")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.playWrongAnswerCallout)
            }) {
                Text("Play Wrong Answer Callout")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.playNoResponseCallout)
            }) {
                Text("Play No Response Callout")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.waitingForResponse)
            }) {
                Text("Waiting For Response")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.receivedResponse)
            }) {
                Text("Received Response")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.nextQuestion)
            }) {
                Text("Next Question")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.reviewing)
            }) {
                Text("Reviewing")
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.playQuestionAudioUrl(url: "https://storage.googleapis.com/buildship-ljnsun-us-central1/Here we go, good luck.mp3"))
            }) {
                Text("Play Question Audio URL")
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.playAnswer(url: "https://storage.googleapis.com/buildship-ljnsun-us-central1/Nice! That's the right answer!.mp3"))
            }) {
                Text("Play Answer Audio URL")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                playAudioAction(.playFeedbackMessage(url: "https://storage.googleapis.com/buildship-ljnsun-us-central1/You have chosen to quit the quiz.mp3"))
            }) {
                Text("Play Feedback Message")
                    .padding()
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            initializeSession()
        }
    }

    private func initializeSession() {
        let audioFileSorter = AudioFileSorter(randomGenerator: SystemRandomNumberGenerator())
        audioFileSorter.configure(with: config)
        //audioPlayer = SessionAudioPlayer(context: viewModel.quizSessionManager.quizSession, audioFileSorter: audioFileSorter)
    }

    private func playAudioAction(_ action: AudioAction) {
        audioPlayer?.performAudioAction(action)
    }
}



