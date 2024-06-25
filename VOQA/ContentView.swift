//
//  ContentView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var databaseManager = DatabaseManager.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @StateObject private var quizContext: QuizContext

    // Define all queries
    @Query var standardQuizPackages: [StandardQuizPackage]
    @Query var customQuizPackages: [CustomQuizPackage]
    @Query var topics: [Topic]
    @Query var questions: [Question]
    @Query var audioQuizzes: [AudioQuiz]
    @Query var performances: [Performance]
    @Query var voiceFeedbackMessages: [VoiceFeedbackMessages]

    @State private var config = homePageConfig
    @State private var isSignedIn = false

    init() {
        let context = QuizContext(state: IdleState())
        let audioPlayer = AudioContentPlayer(context: context)
        let quizModerator = QuizModerator(context: context)
        context.audioPlayer = audioPlayer
        context.quizModerator = quizModerator
        _quizContext = StateObject(wrappedValue: context)
    }

    var body: some View {
        VStack {
            if isSignedIn {
                HomePage(quizContext: quizContext, config: config)
            } else {
                SignInView(isSignedIn: $isSignedIn)
            }
        }
        .task {
            setupDataLayer()
        }
        .alert(item: $databaseManager.currentError) { error in
            Alert(
                title: Text(error.title ?? "Error"),
                message: Text(error.message ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(item: $networkMonitor.connectionError) { error in
            Alert(
                title: Text(error.title ?? "Network Error"),
                message: Text(error.message ?? "An unknown network error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay(
            databaseManager.showFullPageError ? fullPageErrorView : nil
        )
        .environmentObject(quizContext)
    }
}

struct SignInView: View {
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .padding()

            Button(action: {
                isSignedIn = true
            }) {
                Text("Sign In")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}



#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

extension ContentView {
    func setupDataLayer() {
        // Initialize DataService
        databaseManager.setupDataService(id: UUID(), downloadUrl: Config.audioRequestURL)
        guard voiceFeedbackMessages.isEmpty else {
            var itemCount = 0
            for item in voiceFeedbackMessages {
                itemCount += 1
                print("VoiceFeedbackMessages ID: \(item.id), has: \(itemCount) items")
            }
            return
        }
        // Load Voice Feedback Messages
        let voiceFeedbackContainer = loadMainVoiceFeedBackMessages()
        
        // Download Voice Feedback Messages
        databaseManager.downloadVoiceFeedbackMessages(container: voiceFeedbackContainer) { result in
            switch result {
            case .success(let messages):
                
                modelContext.insert(messages)
                
                do {
                    try modelContext.save()
                    
                } catch {
                    print("Failed to save new voice feedback messages: \(error)")
                }
                
                print("Downloaded voice feedback messages: \(messages)")
            case .failure(let error):
                print("Failed to download voice feedback messages: \(error)")
            }
        }
    }
    
    
    var fullPageErrorView: some View {
        VStack {
            Text(databaseManager.currentError?.title ?? "Error")
                .font(.largeTitle)
                .padding()
            Text(databaseManager.currentError?.message ?? "An unknown error occurred.")
                .padding()
            Button(action: {
                // Handle retry logic here
                databaseManager.showFullPageError = false
            }) {
                Text("Retry")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func loadMainVoiceFeedBackMessages() -> VoiceFeedbackContainer {
        return VoiceFeedbackContainer(
            id: UUID(),
            quizStartMessageScript: "Get ready for a new quiz.",
            quizEndingMessageScript: "Well done! This quiz is now complete.",
            nextQuestionCalloutScript: "Next question coming up.",
            finalQuestionCalloutScript: "This is the final question.",
            repeatQuestionCalloutScript: "Repeating the last question.",
            listeningCalloutScript: "I'm listening...",
            waitingForResponseCalloutScript: "I didn't register a response so I'll skip this question.",
            pausedCalloutScript: "Quiz is now paused.",
            correctAnswerCalloutScript: "That's the correct answer!",
            correctAnswerLowStreakCallOutScript: "Correct! You're on a streak.",
            correctAnswerMidStreakCalloutScript: "Correct yet again! You're on fire! Let's keep going.",
            correctAnswerHighStreakCalloutScript: "Amazing! That's a perfect streak!",
            inCorrectAnswerCalloutScript: "That's not quite right.",
            zeroScoreCommentScript: "No points earned. Try harder next time.",
            tenPercentScoreCommentScript: "You scored ten percent. Practice makes perfect.",
            twentyPercentScoreCommentScript: "You scored twenty percent. Let's keep learning.",
            thirtyPercentScoreCommentScript: "Thirty percent scored, you're getting there.",
            fortyPercentScoreCommentScript: "Forty percent scored, good effort.",
            fiftyPercentScoreCommentScript: "Halfway there! You scored fifty percent!",
            sixtyPercentScoreCommentScript: "Sixty percent scored, well done!",
            seventyPercentScoreCommentScript: "You scored seventy percent, great job!",
            eightyPercentScoreCommentScript: "You scored an impressive eighty percent, excellent work.",
            ninetyPercentScoreCommentScript: "Wow! You scored ninety percent, almost a perfect score! Great job!",
            perfectScoreCommentScript: "Perfect score! You got all questions correct! Congratulations!",
            errorTranscriptionScript: "Error transcribing your response. Skipping this question for now.",
            invalidResponseCalloutScript: "I did not register your response so this question will be marked as unanswered and will not count towards your final score. Unanswered questions will be randomly presented at different quizzes.",
            invalidResponseUserAdvisoryScript: "Please try to respond with valid options only. Invalid responses are skipped.",
            quizStartAudioUrl: "https://example.com/audio/quizStart.mp3",
            quizEndingAudioUrl: "https://example.com/audio/quizEnd.mp3",
            nextQuestionCalloutAudioUrl: "https://example.com/audio/nextQuestion.mp3",
            finalQuestionCalloutAudioUrl: "https://example.com/audio/finalQuestion.mp3",
            repeatQuestionCalloutAudioUrl: "https://example.com/audio/repeatQuestion.mp3",
            listeningCalloutAudioUrl: "https://example.com/audio/listening.mp3",
            waitingForResponseCalloutAudioUrl: "https://example.com/audio/waitingForResponse.mp3",
            pausedCalloutAudioUrl: "https://example.com/audio/paused.mp3",
            correctAnswerCalloutAudioUrl: "https://example.com/audio/correctAnswer.mp3",
            correctAnswerLowStreakCallOutAudioUrl: "https://example.com/audio/correctLowStreak.mp3",
            correctAnswerMidStreakCalloutAudioUrl: "https://example.com/audio/correctMidStreak.mp3",
            correctAnswerHighStreakCalloutAudioUrl: "https://example.com/audio/correctHighStreak.mp3",
            inCorrectAnswerCalloutAudioUrl: "https://example.com/audio/incorrectAnswer.mp3",
            zeroScoreCommentAudioUrl: "https://example.com/audio/zeroScore.mp3",
            tenPercentScoreCommentAudioUrl: "https://example.com/audio/tenPercentScore.mp3",
            twentyPercentScoreCommentAudioUrl: "https://example.com/audio/twentyPercentScore.mp3",
            thirtyPercentScoreCommentAudioUrl: "https://example.com/audio/thirtyPercentScore.mp3",
            fortyPercentScoreCommentAudioUrl: "https://example.com/audio/fortyPercentScore.mp3",
            fiftyPercentScoreCommentAudioUrl: "https://example.com/audio/fiftyPercentScore.mp3",
            sixtyPercentScoreCommentAudioUrl: "https://example.com/audio/sixtyPercentScore.mp3",
            seventyPercentScoreCommentAudioUrl: "https://example.com/audio/seventyPercentScore.mp3",
            eightyPercentScoreCommentAudioUrl: "https://example.com/audio/eightyPercentScore.mp3",
            ninetyPercentScoreCommentAudioUrl: "https://example.com/audio/ninetyPercentScore.mp3",
            perfectScoreCommentAudioUrl: "https://example.com/audio/perfectScore.mp3",
            errorTranscriptionAudioUrl: "https://example.com/audio/errorTranscription.mp3",
            invalidResponseCalloutAudioUrl: "https://example.com/audio/invalidResponse.mp3",
            invalidResponseUserAdvisoryAudioUrl: "https://example.com/audio/invalidResponseUserAdvisory.mp3"
        )
    }
}
