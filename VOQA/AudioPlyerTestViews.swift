//
//  AudioPlyerTestViews.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/20/24.
//

import SwiftUI


struct AudioPlyerTestViews: View {
    var body: some View {
        QuestionDetailView(questions: sampleQuestions)
        //BaseMainView()
        .preferredColorScheme(.dark)
            
    }
}

#Preview {
    AudioPlyerTestViews()
}


struct QuestionDetailView: View {
    @State private var showSiriAlert = false
    
    @State private var isPlaying = false
    var questions: [Question]
    
    init(questions: [Question]) {
        self.questions = questions
        let context = QuizContext(state: IdleState())
        let quizContext = QuizContext(state: IdleState())
        //_quizContext = StateObject(wrappedValue: context)
        context.audioPlayer = AudioContentPlayer(context: context)
        context.quizModerator = QuizModerator(context: context)
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
                        quizContext.audioPlayer?.playQuestions(questions)
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
                .alert(isPresented: $quizContext.audioPlayer?.appError) {
                    Alert(title: Text("Missing Audio"), message: Text("Would you like to read the question with Siri?"), primaryButton: .default(Text("Yes")) {
                        //quizContext.audioPlayer?.playWithSiri(question.audioScript)
                    }, secondaryButton: .cancel())
                }
                
                Button(action: {
                    //quizContext.audioPlayer?.skipToQuestion(withId: question.id)
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
            
        }
        .onChange(of: quizContext.audioPlayer?.appError ?? nil, { _, error in
            if let appError = error {
                showSiriAlert = true
            }
        })
        .onAppear {
            quizContext.startQuiz()
            if let player = quizContext.audioPlayer {
                player.questions = sampleQuestions
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
            .frame(height: 120)
        }
        .presentationDetents([.medium])
    }
}

let sampleQuestions: [Question] = [
    Question(id: UUID(), topicId: UUID(), content: "What is the capital of France?", options: ["Paris", "London", "Berlin", "Madrid"], correctOption: "A", audioScript: "New Question, what is the capital of France.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the capital of France.", replayOptionAudioScript: "Options are: Paris, London, Berlin, Madrid"),
    Question(id: UUID(), topicId: UUID(), content: "What is the currency of Japan?", options: ["Yen", "Dollar", "Euro", "Pound"], correctOption: "A", audioScript: "New Question, what is the currency of Japan.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the currency of Japan.", replayOptionAudioScript: "Options are: Yen, Dollar, Euro, Pound"),
    Question(id: UUID(), topicId: UUID(), content: "Who is the current President of the USA?", options: ["Joe Biden", "Donald Trump", "Barack Obama", "George Bush"], correctOption: "A", audioScript: "New Question, who is the current President of the USA.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, who is the current President of the USA.", replayOptionAudioScript: "Options are: Joe Biden, Donald Trump, Barack Obama, George Bush"),
    Question(id: UUID(), topicId: UUID(), content: "What is the tallest mountain in the world?", options: ["Mount Everest", "K2", "Kangchenjunga", "Lhotse"], correctOption: "A", audioScript: "New Question, what is the tallest mountain in the world.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the tallest mountain in the world.", replayOptionAudioScript: "Options are: Mount Everest, K2, Kangchenjunga, Lhotse"),
    Question(id: UUID(), topicId: UUID(), content: "What is the chemical symbol for water?", options: ["H2O", "O2", "CO2", "H2"], correctOption: "A", audioScript: "New Question, what is the chemical symbol for water.", audioUrl: "smallVoiceOver.mp3", replayQuestionAudioScript: "Please repeat, what is the chemical symbol for water.", replayOptionAudioScript: "Options are: H2O, O2, CO2, H2")
]


struct BaseMainView: View {
    @State private var currentView: String = "Home"
    @State private var showProfile = false
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        Image("VoqaIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: getOffset().width, y: getOffset().height)
                            .animation(.easeInOut(duration: 2.0), value: currentView)
                            .offset(y: -60)
                    }
                }

                VStack {
                    switch currentView {
                    case "Home":
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 600)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom))
                            .overlay {
                                VStack {
                                    Text("Home Screen")
                                        .padding()
                                        .offset(y: -10)
                                }
                            }
                    case "Profile":
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 600)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .leading))
                            .overlay {
                                VStack {
                                    Text("Profile View Content")
                                        .padding()
                                        .offset(y: -10)
                                }
                            }
                    case "Settings":
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 600)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .trailing))
                            .overlay {
                                VStack {
                                    Text("Settings View Content")
                                        .padding()
                                        .offset(y: -10)
                                }
                            }
                    default:
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Material.ultraThin)
                            .frame(width: 350, height: 700)
                        //Text("Home View Content")
                    }
                }
                .font(.title)
                .padding()
                .animation(.easeInOut(duration: 2.0), value: currentView)
                
            }
            .navigationTitle(getTitle())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            currentView = "Profile"
                        }
                    }) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            currentView = "Settings"
                        }
                    }) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                switch currentView {
                case "Home":
                    withAnimation {
                        currentView = "Profile"
                    }
                case "Profile":
                    withAnimation {
                        currentView = "Settings"
                    }
                case "Settings":
                    withAnimation {
                        currentView = "Home"
                    }
                default:
                    withAnimation {
                        currentView = "Home"
                    }
                }
            }
        }
    }
    
    private func getTitle() -> String {
        switch currentView {
        case "Home":
            return "Home"
        case "Profile":
            return "Profile"
        case "Settings":
            return "Settings"
        default:
            return "Home"
        }
    }

    private func getOffset() -> CGSize {
        switch currentView {
        case "Home":
            return .zero
        case "Profile":
            return CGSize(width: 350, height: -250)
        case "Settings":
            return CGSize(width: -350, height: 250)
        default:
            return .zero
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseMainView()
//    }
//}





