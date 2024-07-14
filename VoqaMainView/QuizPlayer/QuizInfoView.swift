//
//  QuizInfoView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import SwiftUI

import SwiftUI

struct QuizInfoView: View {
    let selectedVoqa: Voqa
    @Environment(\.dismiss) private var dismiss
    @Environment(\.quizSessionConfig) private var config: QuizSessionConfig?
    @StateObject private var databaseManager = DatabaseManager.shared
    @State private var questionsLoaded: Bool = false
    @State private var isDownloading: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                if let url = URL(string: selectedVoqa.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 180, height: 180)
                                .cornerRadius(15)
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 180, height: 180)
                                .cornerRadius(15)
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .cornerRadius(15)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            VStack(alignment: .center) {
                Text(selectedVoqa.name)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .center) {
                Text(selectedVoqa.about)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                isDownloading = true
                Task {
                    await getQuestions()
                    isDownloading = false
                }
            }) {
                if isDownloading {
                    Text("Downloading...")
                } else {
                    Text("Start Assessment Quiz")
                }
            }
            .fontWeight(.black)
            .foregroundColor(.black)
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(isDownloading)
            
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.bottom, 20)
        }
        .frame(maxHeight: .infinity)
        .background {
            if let url = URL(string: selectedVoqa.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 3.0)
                            .offset(x: -100)
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.red)
                            .blur(radius: 3.0)
                            .offset(x: -100)
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.red)
                    .blur(radius: 3.0)
                    .offset(x: -100, y: 60)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.6))
                    }
            }
        }
        .alert(item: $databaseManager.currentError) { error in
            Alert(title: Text("Error"), message: Text(error.message ?? ""), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $questionsLoaded) {
            if let config = config {
                QuizPlayerView(config: config, selectedVoqa: selectedVoqa)
                    .environment(\.questions, databaseManager.questions)
            }
        }
    }
    
    func getQuestions() async {
        await databaseManager.fetchQuestions()
        if !databaseManager.questions.isEmpty {
            questionsLoaded = true
        }
    }
}


#Preview {
    QuizInfoView(selectedVoqa: Voqa(id: UUID(), name: "Sample Quiz", acronym: "SQ", about: "A sample quiz", imageUrl: "", rating: 3, curator: "John Doe", users: 1000))
        .preferredColorScheme(.dark)
}
