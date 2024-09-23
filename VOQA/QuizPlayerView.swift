//
//  QuizPlayerView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import SwiftUI
import Foundation
import Combine

struct QuizPlayerView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: QuizViewModel
    
    @State var currentRating: Int? = 1
    @State var isNowPlaying: Bool = false
    @State private var audioPlayer: SessionAudioPlayer? // Assuming this manages audio playback
    @State private var cancellables: Set<AnyCancellable> = []
    
    var config: QuizSessionConfig
    var voqa: Voqa
    
    // Initialize ViewModel with required managers
    init(config: QuizSessionConfig, voqa: Voqa) {
        self.config = config
        self.voqa = voqa
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
    }

    var body: some View {
        VStack {
            quizHeaderView() // Header for question count and time
            quizQuestionView() // Display question text
            Spacer()
            quizOptionsScrollView() // Scrollable options
            Spacer()
            quizControlGridView() // Control buttons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(quizBackgroundView()) // Background image with overlay
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$sessionNowplayingAudio, perform: { nowPlaying in
            DispatchQueue.main.async {
                self.isNowPlaying = nowPlaying
            }
        })
        .onChange(of: viewModel.sessionNowplayingAudio) { _, nowPlaying in
            DispatchQueue.main.async {
                self.isNowPlaying = nowPlaying
            }
        }
        .onAppear {
            configureNewSession() // Configure the new session
        }
    }

    // MARK: - Initial Setup for Quiz Session
    private func configureNewSession() {
        var updatedConfig = config
        updatedConfig.sessionTitle = voqa.quizTitle

        // Since sessionQuestion is already [Question], no need to cast
        let questions = updatedConfig.sessionQuestion

        viewModel.initializeSession(with: updatedConfig)
        viewModel.startNewQuizSession(questions: questions)

        print(updatedConfig.sessionTitle)
        print(updatedConfig.sessionVoice)
        print(questions.count)
    }


    // MARK: - View Builders (Same as before, with additions as needed)
    
    @ViewBuilder
    private func quizHeaderView() -> some View {
        HStack {
            Text("Question: \(viewModel.currentQuestionIndex + 1)/\(config.sessionQuestion.count)")
                .font(.headline)
            Spacer()
            Text("Time: \(viewModel.sessionTimer)")
                .font(.callout)
                .padding(.horizontal)
                .foregroundStyle(.orange.opacity(0.9))
        }
        .padding(.horizontal)
        .offset(y: 10)
    }

    @ViewBuilder
    private func quizQuestionView() -> some View {
        VStack {
            Text(viewModel.currentQuestionText)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.fromHex(voqa.colors.main).gradient)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Material.ultraThin)
                }
        )
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom)
    }

    @ViewBuilder
    private func quizOptionsScrollView() -> some View {
        // Safely access the current question using currentQuestionIndex
        if let question = config.sessionQuestion[safe: viewModel.currentQuestionIndex] {
            ScrollView {
                ForEach(question.mcOptions.keys.sorted(), id: \.self) { option in
                    quizOptionButton(option: option, color: Color.fromHex(voqa.colors.main))
                }
            }
        } else {
            Text("No question available.")
        }
    }


    @ViewBuilder
    private func quizOptionButton(option: String, color: Color) -> some View {
        let optionColor = colorForOption(option: option)
        Button(action: {
            viewModel.selectAnswer(selectedOption: option)
        }) {
            Text(option)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(optionColor.opacity(0.15))
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(optionColor.opacity(optionColor == .black ? 0.15 : 1), lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
//        .padding(.top)
//        .padding(.bottom)
    }

    @ViewBuilder
    private func quizControlGridView() -> some View {
        HStack {
            Button(action: {
                viewModel.stopQuiz()
            }) {
                Image(systemName: "stop.fill")
                    .font(.title)
                    .foregroundColor(.red.opacity(0.8))
            }
            .padding()

            Button(action: {
                viewModel.repeatQuestion()
            }) {
                Image(systemName: "repeat")
                    .font(.title)
                    .foregroundColor(Color.fromHex(voqa.colors.main))
            }
            .padding()

            Button(action: {
                isNowPlaying.toggle()
            }) {
                Image(systemName: isNowPlaying ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay {
                Circle()
                    .stroke(lineWidth: 5.0)
                    .foregroundStyle(Color.fromHex(voqa.colors.main))
            }

            Button(action: {
                // Mic toggle logic
            }) {
                Image(systemName: "mic")
                    .font(.title)
                    .foregroundColor(Color.fromHex(voqa.colors.main))
            }
            .padding()

            Button(action: {
                viewModel.nextQuestion()
            }) {
                Image(systemName: "forward.end.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(alignment: .bottom)
        .padding(.horizontal)
        .padding()
        .background(Color.black) // Ensures background color spans the entire control grid
    }

    @ViewBuilder
    private func quizBackgroundView() -> some View {
        CachedImageView(imageUrl: voqa.imageUrl)
            .aspectRatio(contentMode: .fill)
            .overlay {
                Rectangle()
                    .foregroundStyle(.black.opacity(0.95)) // Dark overlay on the image
            }
            .edgesIgnoringSafeArea(.all) // Make sure it covers the whole screen
    }

    private func colorForOption(option: String) -> Color {
        // Access the underlying Question using `wrappedValue`
        guard let currentQuestion = $viewModel.currentQuestion.wrappedValue else {
            return .pink
        }
        
        // Unwrap the optional correctOption and selectedOption
        let correctOption = currentQuestion.correctOption ?? ""
        let selectedOption = currentQuestion.selectedOption ?? ""

        if viewModel.sessionAwaitingResponse {
            return Color.fromHex(voqa.colors.main)
        } else if option == correctOption {
            return .green
        } else if option == selectedOption {
            return .red
        } else {
            return .black
        }
    }

}

