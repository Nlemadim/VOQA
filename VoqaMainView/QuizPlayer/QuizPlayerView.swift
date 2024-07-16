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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.questions) private var questions
    
    @StateObject private var viewModel: QuizViewModel
    
    @State var currentRating: Int? = 3
    @State private var audioPlayer: SessionAudioPlayer?
    @State private var cancellables: Set<AnyCancellable> = []
    
    var selectedVoqa: Voqa
    let config: QuizSessionConfig
    
    init(config: QuizSessionConfig, selectedVoqa: Voqa) {
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
        self.config = config
        self.selectedVoqa = selectedVoqa
    }
    
    var body: some View {
        Group {
            if questions.isEmpty {
                quizInfoView()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    // SESSION INTERACTION VIEW
                    sessionInteractionView()

                    // CURRENT CONTENT VIEW
                    currentContentView()

                    // Buttons Grid View
                    Divider()
                        .activeGlow(.white, radius: 0.5)

                    // InteractionButtons Grid
                    quizControlButtons()
                    
                }
                .padding()
                .background {
                    QuizPlayerBackground(backgroundImageResource: selectedVoqa.imageUrl)
                }
                .onChange(of: viewModel.sessionAwaitingResponse, { _, newValue in
                    print("Awaiting response? New value \(newValue)")
                })
                .onAppear {
                    viewModel.initializeSession(with: self.config)
                    print("QuizPlayer has: \(questions.count) questions")
                    viewModel.startNewQuizSession(questions: questions)
                }
            }
        }
    }
    
    private func quizControlButtons() -> some View {
        QuizControlButtonsGrid(
            awaitingResponse: $viewModel.sessionAwaitingResponse,
            selectButton: { option in
                viewModel.selectAnswer(selectedOption: option)
            },
            centralAction: {})
    }

    @ViewBuilder
    private func quizInfoView() -> some View {
        QuizInfoView(selectedVoqa: selectedVoqa)
    }

    @ViewBuilder
    private func sessionInteractionView() -> some View {
        VStack(spacing: 10) {
            HStack {
                if let url = URL(string: selectedVoqa.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .frame(height: 100)
                                .padding(.horizontal)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .frame(height: 100)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(height: 100)
                        .foregroundColor(.red)
                }

                VStack {
                    Text(selectedVoqa.name)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        .padding(.top, 2)
                        .hAlign(.leading)

                    Text("Audio Quiz")
                        .font(.footnote)
                        .padding(.top, 2)
                        .foregroundStyle(.primary)
                        .hAlign(.leading)

                    ZStack {
                        Text(viewModel.sessionQuestionCounterText)
                            .font(.footnote)
                            .padding(.top, 2)
                            .foregroundStyle(.primary)
                            .hAlign(.leading)
                    }
                }
                .kerning(-0.2)
                .fontWeight(.semibold)
                .frame(height: 100)

                StopQuizButton(
                    stopAction: {
                        dismiss()
                        viewModel.stopQuiz()
                    }
                )
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top)

            ZStack {
                VoqaSpeechVisualizer(colors: [.mint, .purple, .teal], supportLineColor: .teal, switchOn: .constant(viewModel.sessionNowplayingAudio))
                    .frame(height: 25)
                    .padding()
            }
        }
    }

    @ViewBuilder
    private func currentContentView() -> some View {
        VStack(alignment: .center) {
            FormattedQuestionContentView(questionTranscript: viewModel.currentQuestionText)
            Spacer()
            Text("Rate This Question")
                .font(.system(size: 8))
                .foregroundStyle(.secondary)
            RatingsView(
                maxRating: 4,
                currentRating: $currentRating,
                width: 30,
                color: .systemTeal,
                sfSymbol: "star"
            )
        }
        .frame(maxHeight: .infinity)
    }
}


//
//#Preview {
//    let config = QuizSessionConfig()
//    let controller = QuizController(sessionConfig: config)
//    return QuizPlayerView(controller: controller, selectedVoqa: Voqa(id: UUID(), name: "Sample Quiz", acronym: "SQ", about: "A sample quiz", imageUrl: "", rating: 3, curator: "John Doe", users: 1000))
//        .preferredColorScheme(.dark)
//}






//#Preview {
//    let config = QuizSessionConfig()
//    let controller = QuizController(sessionConfig: config)
//    return QuizPlayerView(controller: controller, selectedVoqa: Voqa(id: UUID(), name: "Sample Quiz", acronym: "SQ", about: "A sample quiz", imageUrl: "", rating: 3, curator: "John Doe", users: 1000))
//        .preferredColorScheme(.dark)
//}

