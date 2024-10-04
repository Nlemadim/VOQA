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
   
    @ObservedObject var config: QuizSessionConfig
    
    @StateObject private var viewModel: QuizViewModel
    
    @State var currentRating: Int? = 1
    @State var isNowPlaying: Bool = false
    @State private var audioPlayer: SessionAudioPlayer? // Assuming this manages audio playback
    @State private var cancellables: Set<AnyCancellable> = []
    
    var voqa: VoqaItem
    
    // Initialize ViewModel with required managers
    init(config: QuizSessionConfig, voqa: Voqa) {
        self.config = config
        self.voqa = voqa
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
    }
    
    // New initializer using VoqaItem protocol
    init(config: QuizSessionConfig, voqaItem: VoqaItem) {
        self.config = config
        self.voqa = voqaItem
        print("Initialized QuizPlayerView with config: \(config.sessionId)")
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
    }

    var body: some View {
        VStack {
            quizHeaderView() // Header for question count and time
                .padding()
            //quizQuestionView() // Display question text
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
        let updatedConfig = config
        updatedConfig.sessionTitle = voqa.quizTitle
        viewModel.initializeSession(with: updatedConfig)
        viewModel.startQuiz()

    }


    // MARK: - View Builders (Same as before, with additions as needed)
    
    @ViewBuilder
    private func quizHeaderView() -> some View {
        HStack(alignment: .center, spacing: 16) {
            // Image for the voqaItem
            CachedImageView(imageUrl: voqa.imageUrl)
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 25) {
                // Title for the voqaItem
                Text(voqa.quizTitle)
                    .font(.headline)
                    .bold()
                    .padding(.horizontal)
                
                // Question counter
                Text("Question: \(viewModel.currentQuestionIndex + 1)/\(config.sessionQuestion.count)")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                // Timer
                Text("Time: \(viewModel.sessionTimer)")
                    .font(.callout)
                    .foregroundStyle(.orange.opacity(0.9))
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Material.ultraThin)
        )
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
                    quizOptionButton(
                        option: option,
                        color: colorForOption(option: option, question: question),
                        onSelect: { selectedOption in
                            viewModel.selectAnswer(for: question, selectedOption: selectedOption)
                        }
                    )
                }
            }
        } else {
            Text("No question available.")
        }
    }

    @ViewBuilder
    private func quizOptionButton(option: String, color: Color, onSelect: @escaping (String) -> Void) -> some View {
        Button(action: {
            onSelect(option)  // Trigger the callback when an option is selected
        }) {
            Text(option)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(color == .black ? 0.15 : 1), lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .padding(10)
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
                viewModel.startQuiz()
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
                    .foregroundStyle(.black.opacity(0.85)) // Dark overlay on the image
            }
            .edgesIgnoringSafeArea(.all) // Make sure it covers the whole screen
    }

    private func colorForOption(option: String, question: Question) -> Color {
        guard let isCorrect = question.mcOptions[option] else { return .gray }
        
        // If the question is answered, highlight based on correctness
//        if let isAnswered = question.isAnsweredOptional, isAnswered {
//            return isCorrect ? .green : .red
//        }
        
        // If no selection is made, default to gray
        return .gray
    }
}


#Preview {
    TestQuizPlayerPreview()
        .preferredColorScheme(.dark)
}
