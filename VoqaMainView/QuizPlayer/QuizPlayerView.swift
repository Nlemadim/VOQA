//
//  QuizPlayerView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import SwiftUI
import Combine

struct QuizPlayerView: View {
    @StateObject private var controller: QuizController
    @Environment(\.dismiss) private var dismiss
    @State var currentRating: Int? = 3
    @State var isActiveQuiz: Bool = false
    var selectedVoqa: Voqa

    init(config: QuizSessionConfig, selectedVoqa: Voqa) {
        _controller = StateObject(wrappedValue: QuizController(sessionConfig: config))
        self.selectedVoqa = selectedVoqa
    }

    var body: some View {
        Group {
            if controller.session.questions.isEmpty {
                
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
                    QuizControlButtonsGrid(selectButton: { _ in }, centralAction: {})
                        .hAlign(.center)
                       
                }
                .padding()
                .background {
                    QuizPlayerBackground(backgroundImageResource: selectedVoqa.imageUrl)
                        
                }
            }
        }
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
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .padding(.top, 2)
                        .hAlign(.leading)
                    
                    Text("Audio Quiz")
                        .font(.subheadline)
                        .padding(.top, 2)
                        .foregroundStyle(.primary)
                        .hAlign(.leading)
                    
                    ZStack {
                        Text(controller.currentQuestionText)
                            .font(.subheadline)
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
                        controller.stopQuiz()
                    }
                )
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top)
            
            ZStack {
                VoqaSpeechVisualizer(colors: [.mint, .purple, .teal], supportLineColor: .teal, switchOn: .constant(controller.isActiveQuiz))
                    .frame(height: 25)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private func currentContentView() -> some View {
        VStack(alignment: .center) {
            FormattedQuestionContentView(questionTranscript: controller.currentQuestionText)
            Spacer()
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

