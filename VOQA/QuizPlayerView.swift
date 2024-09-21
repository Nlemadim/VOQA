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
    @State private var audioPlayer: SessionAudioPlayer?
    @State private var cancellables: Set<AnyCancellable> = []
    
    var config: QuizSessionConfig
    var voqa: Voqa
    
    init(config: QuizSessionConfig, voqa: Voqa) {
        self.config = config
        self.voqa = voqa
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // SESSION INTERACTION VIEW
            sessionInteractionView()
            
            // CURRENT CONTENT VIEW
            currentContentView()
            
            // Buttons Grid View
            Divider()
                .activeGlow(.teal, radius: 0.5)
            
            // InteractionButtons Grid
            quizControlButtons()
        }
        .padding()
        .background {
            QuizPlayerBackground(backgroundImageResource: voqa.imageUrl)
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$sessionNowplayingAudio, perform: { nowPlaying in
            DispatchQueue.main.async {
                self.isNowPlaying = nowPlaying
            }
        })
        .onChange(of: viewModel.sessionNowplayingAudio) {_, nowPlaying in
            DispatchQueue.main.async {
                self.isNowPlaying = nowPlaying
            }
        }
        .onChange(of: viewModel.currentQuestionIndex) {_, _ in
            viewModel.playNextQuestionSfx()
        }
        .onChange(of: viewModel.sessionAwaitingResponse) {_, awaitingResponse in
            if awaitingResponse {
                viewModel.playAwaitingResponseSfx()
            } else {
                viewModel.playRecievedResponseSfx()
            }
        }
        .onAppear {
            configureNewSession()
            if !config.sessionQuestion.isEmpty {
                print("Config has questions")
            } else {
                print("Config has no questions")
            }
        }
    }
    
    private func configureNewSession() {
        var updatedConfig = config
        updatedConfig.sessionTitle = voqa.quizTitle
        viewModel.initializeSession(with: updatedConfig)
        viewModel.startNewQuizSession(questions: updatedConfig.sessionQuestion)
        print(updatedConfig.sessionTitle)
        print(updatedConfig.sessionVoice)
        print(updatedConfig.sessionQuestion.count)
         
    }
    
    private func quizControlButtons() -> some View {
        QuizControlButtonsGrid(
            awaitingResponse: $viewModel.sessionAwaitingResponse,
            selectButton: { option in
                viewModel.selectAnswer(selectedOption: option)
            },
            centralAction: { viewModel.playRecievedResponseSfx() }
        )
    }

//    private func playbackVisualizer() -> some View {
//        viewModel.playbackVisualizer()
//    }

    @ViewBuilder
    private func sessionInteractionView() -> some View {
        VStack(spacing: 10) {
            HStack {
                if let url = URL(string: voqa.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
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

                VStack(spacing: 4) {
                    Text(voqa.acronym)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(viewModel.sessionQuestionCounterText)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Uncomment and implement VUMeterView if needed
                    // if let session = viewModel.currentSession() {
                    //     VUMeterView(quizContext: session)
                    //         .padding(.top, 2)
                    //         .frame(maxWidth: .infinity, alignment: .leading)
                    // }
                }
                .kerning(-0.2)
                .frame(height: 80)

                StopQuizButton(
                    stopAction: {
                        viewModel.stopQuiz()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    }
                )
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .activeGlow(.teal, radius: 0.5)
        }
    }
    
    private func animateVisualizer(nowPlaying: Bool) {
        self.isNowPlaying = nowPlaying
    }

    @ViewBuilder
    private func currentContentView() -> some View {
        VStack(alignment: .center) {
            ZStack {
                FormattedQuestionContentView(questionTranscript: viewModel.currentQuestionText)
                
                FormattedCountDownTextView(countdownTimerText: "viewModel.countdownTimerText")
                
                RateQuizView(currentRating: $currentRating)
            }
        }
        .frame(maxHeight: .infinity)
    }
}


//#Preview {
//    
//    var voqa: Voqa = Voqa(id: UUID().uuidString, quizTitle: "Sample Quiz", acronym: "SQ", about: "A sample quiz", imageUrl: "IconImage", rating: 5, curator: "Gista", users: 56, tags: ["A sample"], colors: themeColor, ratings: 99, requiresSubscription: true)
//
//    let controller = QuizConfigManager()
//    return QuizPlayerView(config: controller.config ?? <#default value#>, selectedVoqa: voqa)
//        .preferredColorScheme(.dark)
//}

//var themeColor: ThemeColors = ThemeColors(main: "", sub: "", third: "")



//#Preview {
//    let config = QuizSessionConfig()
//    let controller = QuizController(sessionConfig: config)
//    return QuizPlayerView(controller: controller, selectedVoqa: Voqa(id: UUID(), name: "Sample Quiz", acronym: "SQ", about: "A sample quiz", imageUrl: "", rating: 3, curator: "John Doe", users: 1000))
//        .preferredColorScheme(.dark)
//}

