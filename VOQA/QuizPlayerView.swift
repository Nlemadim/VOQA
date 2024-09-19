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
    @Environment(\.questions) private var questions
    
    @StateObject private var viewModel: QuizViewModel
    
    @State var currentRating: Int? = 1
    @State var isNowPlaying: Bool = false
    @State private var audioPlayer: SessionAudioPlayer?
    @State private var cancellables: Set<AnyCancellable> = []
    
    var selectedVoqa: Voqa
    
    init(selectedVoqa: Voqa) {
        let quizSessionManager = QuizSessionManager()
        let quizConfigManager = QuizConfigManager()
        _viewModel = StateObject(wrappedValue: QuizViewModel(quizSessionManager: quizSessionManager, quizConfigManager: quizConfigManager))
        self.selectedVoqa = selectedVoqa
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
            QuizPlayerBackground(backgroundImageResource: selectedVoqa.imageUrl)
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$sessionNowplayingAudio, perform: { nowPlaying in
            DispatchQueue.main.async {
                self.isNowPlaying = nowPlaying
            }
        })
        .onChange(of: viewModel.sessionNowplayingAudio, { _, nowPlaying in
            DispatchQueue.main.async {
                if nowPlaying {
                    self.isNowPlaying = true
                } else {
                    self.isNowPlaying = false
                }
            }
        })
        .onChange(of: viewModel.currentQuestionIndex, { _, _ in
            viewModel.playNextQuestionSfx()
        })
        .onChange(of: viewModel.sessionAwaitingResponse, { _, awaitingResponse in
            if awaitingResponse {
                viewModel.playAwaitingResponseSfx()
            } else {
                viewModel.playRecievedResponseSfx()
            }
        })
        .onAppear {
            if var config = databaseManager.sessionConfiguration {
                config.sessionTitle = selectedVoqa.quizTitle
                viewModel.initializeSession(with: config)
                viewModel.initializeVoqaExperience(questions: questions)
                viewModel.startNewQuizSession(questions: questions)
                print("QuizPlayer has: \(questions.count) questions")
            }
        }
    }
    
    private func quizControlButtons() -> some View {
        QuizControlButtonsGrid(
            awaitingResponse: $viewModel.sessionAwaitingResponse,
            selectButton: { option in
                viewModel.selectAnswer(selectedOption: option)
            },
            centralAction: { viewModel.playRecievedResponseSfx()})
    }

    @ViewBuilder
    private func quizInfoView() -> some View {
        QuizInfoView(selectedVoqa: selectedVoqa)
    }
    

    private func playbackVisualizer() -> any View {
        viewModel.playbackVisualizer()
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

                VStack(spacing: 4) {
                    Text(selectedVoqa.acronym)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .hAlign(.leading)
                    
                    Text(viewModel.sessionQuestionCounterText)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        .hAlign(.leading)
                    
//                    if let session = viewModel.currentSession() {
//                        VUMeterView(quizContext: session)
//                            .padding(.top, 2)
//                            .hAlign(.leading)
//                    }
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
    
    private func animateVisualizer(nowPlaying: Bool)  {
        if nowPlaying == true {
            self.isNowPlaying = true
        } else {
            self.isNowPlaying = false
        }
    }

    @ViewBuilder
    private func currentContentView() -> some View {
        VStack(alignment: .center) {
            ZStack {
                FormattedQuestionContentView(questionTranscript: viewModel.currentQuestionText)
                   // .opacity(viewModel.sessionCountdownTime > 0 ? 0 : 1)
                
                FormattedCountDownTextView(countdownTimerText: "viewModel.countdownTimerText")
                   // .opacity(viewModel.sessionCountdownTime > 0 ? 1 : 0)
                
                RateQuizView(currentRating: $currentRating)
                   // .opacity(viewModel.sessionInReview ? 1 : 0)
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

