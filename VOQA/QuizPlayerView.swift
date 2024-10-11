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
//    @EnvironmentObject var databaseManager: DatabaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var didQuitQuiz: Bool = false
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
            
            QuizHeaderView(voqa: voqa, secondaryInfo: "Audio Quiz")
                .offset(y: -20)
            
            quizQuestionView()
            
            quizOptionsScrollView()
            
            TutorHeaderView(isNowSpeaking: $isNowPlaying, themeColors: [Color.fromHex(voqa.colors.main), Color.fromHex(voqa.colors.sub), Color.fromHex(voqa.colors.third)])
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        
        Rectangle()
         .fill(Color.black)
         .frame(height: 100)
         .overlay{
             quizControlGridView()
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
                .frame(width: 100, height: 100)
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
            ScrollView {
                Text(viewModel.currentQuestionText)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .kerning(-0.5)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .activeGlow(.white, radius: 0.5)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.top)
        .padding(.bottom)
        .background(Color.clear)
    }

    
    @ViewBuilder
       private func quizOptionsScrollView() -> some View {
           // Safely access the current question using currentQuestionIndex
           if let question = viewModel.currentQuestion as? Question {
               VStack(alignment: .center, spacing: 8) {
                   ForEach(question.mcOptions.keys.sorted(), id: \.self) { option in
                       QuizOptionButton(
                           option: option,
                           color: colorForOption(option: option, question: question, isAwaitingResponse: viewModel.sessionAwaitingResponse, hasResponded: viewModel.userHasResponded),
                           onSelect: { selectedOption in
            
                               viewModel.selectAnswer(selectedOption: selectedOption)
                           },
                           viewModel: viewModel
                       )
                       .padding(.horizontal, 5)
                       .environmentObject(TimerManager()) // Inject TimerManager
                       .environmentObject(viewModel) // Inject ViewModel
                   }
               }
           } else {
               Text("No question available.")
                   .foregroundColor(.red)
                   .padding()
           }
       }

    @ViewBuilder
    private func quizControlGridView() -> some View {
        HStack(spacing: 25) {
            Button(action: {
                viewModel.stopQuiz()
                dismiss()
            }) {
                Image(systemName: "stop.fill")
                    .font(.title3)
                    .foregroundColor(.red.opacity(0.8))
            }
            .padding()

            Button(action: {
                viewModel.repeatQuestion()
            }) {
                Image(systemName: "repeat")
                    .font(.title3)
                    .foregroundColor(Color.fromHex(voqa.colors.main))
            }
            .padding()

            Button(action: {
                viewModel.startQuiz()
                isNowPlaying.toggle()
            }) {
                Image(systemName: isNowPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
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
                    .font(.title3)
                    .foregroundColor(Color.fromHex(voqa.colors.main))
            }
            .padding()

            Button(action: {
                viewModel.nextQuestion()
            }) {
                Image(systemName: "forward.end.fill")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
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

    private func colorForOption(option: String, question: any QuestionType, isAwaitingResponse: Bool, hasResponded: Bool) -> Color {
        // If no option is selected yet
        guard let selected = question.selectedOption else {
            if isAwaitingResponse {
                return Color.fromHex(voqa.colors.main) // Color while awaiting response
            } else {
                return .gray // Default color if no response has been made
            }
        }
        
        // If the user has responded, update colors based on selection
        if hasResponded {
            // Check if the current option is the one selected by the user
            if option == selected {
                // Determine if the selected option is correct
                if let question = question as? Question, let isCorrect = question.mcOptions[option] {
                    return isCorrect ? .green : .red // Green for correct, red for incorrect
                }
            } else {
                // If option is not selected, return gray
                return .gray
            }
        }
        return .gray
    }
}


#Preview {
    TestQuizPlayerPreview()
        .preferredColorScheme(.dark)
}


// MARK: - TimerManager
class TimerManager: ObservableObject {
    @Published var currentTime: Date = Date()
    private var timer: AnyCancellable?

    init(interval: TimeInterval = 0.1) {
        timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentTime = date
            }
    }
}

// MARK: - EncryptedText View

struct EncryptedText: View {
    let text: String
    let isEncrypted: Bool
    @EnvironmentObject var timerManager: TimerManager
    @State private var displayedText: String = ""
    
    private let letters: [Character] = [
        // English uppercase letters
        "A","B","C","D","E","F","G","H","I","J","K","L","M",
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
        // English lowercase letters
        "a","b","c","d","e","f","g","h","i","j","k","l","m",
        "n","o","p","q","r","s","t","u","v","w","x","y","z",
        // Greek uppercase letters
        "Α","Β","Γ","Δ","Ε","Ζ","Η","Θ","Ι","Κ","Λ","Μ","Ν",
        "Ο","Π","Ρ","Σ","Τ","Υ","Φ","Χ","Ψ","Ω",
        // Greek lowercase letters
        "α","β","γ","δ","ε","ζ","η","θ","ι","κ","λ","μ","ν",
        "ο","π","ρ","σ","τ","υ","φ","χ","ψ","ω",
        // Cyrillic uppercase letters
        "А","Б","В","Г","Д","Е","Ж","З","И","Й","К","Л","М",
        "Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ",
        "Ъ","Ы","Ь","Э","Ю","Я",
        // Cyrillic lowercase letters
        "а","б","в","г","д","е","ж","з","и","й","к","л","м",
        "н","о","п","р","с","т","у","ф","х","ц","ч","ш","щ",
        "ъ","ы","ь","э","ю","я"
    ]
    
    var body: some View {
        Text(displayedText)
            .font(.system(size: 14, weight: .regular, design: .default))
            .kerning(-0.5)
            .foregroundColor(.white) // Ensure text color matches button styling
            .onAppear {
                updateText()
            }
            .onReceive(timerManager.$currentTime) { _ in
                updateText()
            }
    }
    
    private func updateText() {
        if isEncrypted {
            displayedText = generateEncryptedText()
        } else {
            displayedText = text
        }
    }
    
    private func generateEncryptedText() -> String {
        let groupSize = 8
        let numberOfGroups = 3
        let groups = (0..<numberOfGroups).map { _ in
            (0..<groupSize).compactMap { _ in letters.randomElement() }.map { String($0) }.joined()
        }
        return groups.joined(separator: " ")
    }
}


// MARK: - QuizOptionButton View
struct QuizOptionButton: View {
    let option: String
    let color: Color
    let onSelect: (String) -> Void
    @State private var buttonSelected: Bool = false
    @EnvironmentObject var timerManager: TimerManager
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        Button(action: {
            onSelect(option)
            buttonSelected = true
        }) {
            EncryptedText(text: option, isEncrypted: !viewModel.sessionAwaitingResponse && !viewModel.userHasResponded)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(buttonSelected ? .purple.opacity(0.5) : color.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(buttonSelected ? .purple : color.opacity(color == .black ? 0.15 : 1), lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
        .padding(4)
        .padding(.horizontal)
        .disabled(!viewModel.sessionAwaitingResponse || viewModel.userHasResponded && !buttonSelected)
    }
}
