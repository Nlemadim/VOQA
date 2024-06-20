//
//  AudioPlyerTestViews.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import SwiftUI


struct AudioPlyerTestViews: View {
    var body: some View {
        GalleryView()
            .preferredColorScheme(.dark)
    }
}

#Preview {
    AudioPlyerTestViews()
}


struct GalleryView: View {
    var questions: [Question] = sampleQuestions

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(questions) { question in
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            Text(question.content)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Economics Trivia Quiz")
            .background(
                Image("VoqaIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .background(
            Image("VoqaIcon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
}


struct QuestionDetailView: View {
    @ObservedObject var question: Question
    @State private var showSiriAlert = false
    @StateObject private var audioPlayer = AudioContentPlayer(context: QuizContext(state: IdleState()))
    @State private var isPlaying = false

    var body: some View {
        VStack(spacing: 10) {
            Text(audioPlayer.currentQuestionContent)
                .font(.title2)
                .padding()
            Text(audioPlayer.hasNextQuestion ? "\(audioPlayer.currentQuestionIndex + 1)" : "QUIZ COMPLETE!")
                .padding(.horizontal)
            Text("\(audioPlayer.currentPlaybackPower)")
                .padding(.horizontal)
            
            Spacer()

            HStack(spacing: 20) {
                Button(action: {
                    if question.audioUrl.isEmpty {
                        showSiriAlert = true
                    } else {
                        if isPlaying {
                            audioPlayer.pausePlayback()
                            isPlaying = false
                        } else {
                            audioPlayer.playQuestions(sampleQuestions)
                            isPlaying = true
                        }
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
                        audioPlayer.playWithSiri(question.audioScript)
                    }, secondaryButton: .cancel())
                }

                Button(action: {
                    audioPlayer.skipToQuestion(withId: question.id)
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.red))
                        .foregroundColor(.white)
                }

                Button(action: {
                    audioPlayer.playMultiAudioFiles(mainFile: "VoiceOverSimulation.mp3", bgmFile: "VoqaBgm.mp3")
                }) {
                    Image(systemName: "music.note")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    audioPlayer.stopAndResetPlayer()
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)
        }
    }
}

let sampleQuestions: [Question] = [
    Question(id: UUID(), topicId: UUID(), content: "What is the capital of France?", options: ["Paris", "London", "Berlin", "Madrid"], correctOption: "Paris", isAnsweredCorrectly: false, audioScript: "New Question, what is the capital of France.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the capital of France.", replayOptionAudioScript: "Options are: Paris, London, Berlin, Madrid", status: .newQuestion),
    Question(id: UUID(), topicId: UUID(), content: "What is the currency of Japan?", options: ["Yen", "Dollar", "Euro", "Pound"], correctOption: "Yen", isAnsweredCorrectly: false, audioScript: "New Question, what is the currency of Japan.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the currency of Japan.", replayOptionAudioScript: "Options are: Yen, Dollar, Euro, Pound", status: .newQuestion),
    Question(id: UUID(), topicId: UUID(), content: "Who is the current President of the USA?", options: ["Joe Biden", "Donald Trump", "Barack Obama", "George Bush"], correctOption: "Joe Biden", isAnsweredCorrectly: false, audioScript: "New Question, who is the current President of the USA.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, who is the current President of the USA.", replayOptionAudioScript: "Options are: Joe Biden, Donald Trump, Barack Obama, George Bush", status: .newQuestion),
    Question(id: UUID(), topicId: UUID(), content: "What is the tallest mountain in the world?", options: ["Mount Everest", "K2", "Kangchenjunga", "Lhotse"], correctOption: "Mount Everest", isAnsweredCorrectly: false, audioScript: "New Question, what is the tallest mountain in the world.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the tallest mountain in the world.", replayOptionAudioScript: "Options are: Mount Everest, K2, Kangchenjunga, Lhotse", status: .newQuestion),
    Question(id: UUID(), topicId: UUID(), content: "What is the chemical symbol for water?", options: ["H2O", "O2", "CO2", "H2"], correctOption: "H2O", isAnsweredCorrectly: false, audioScript: "New Question, what is the chemical symbol for water.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the chemical symbol for water.", replayOptionAudioScript: "Options are: H2O, O2, CO2, H2", status: .newQuestion)
]
