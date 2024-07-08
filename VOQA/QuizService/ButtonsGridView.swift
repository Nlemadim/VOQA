//
//  ButtonsGridView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import SwiftUI

struct ButtonsGridView: View {
    @ObservedObject var quizSessionManager: QuizSessionManager
    @State private var isPlaying: Bool = false

    var body: some View {
        HStack {
            // MARK: A Button
            Button(action: {
                quizSessionManager.selectAnswer(selectedOption: "A")
            }) {
                Text("A")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
            .foregroundStyle(quizSessionManager.quizSession.isAwaitingResponse ? .green : quizSessionManager.quizSession.isNowPlaying ? .clear : .gray)
            .opacity(quizSessionManager.quizSession.activeQuiz ? 1 : 0)
            
            // MARK: B Button
            Button(action: {
                quizSessionManager.selectAnswer(selectedOption: "B")
            }) {
                Text("B")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
            .foregroundStyle(quizSessionManager.quizSession.isAwaitingResponse ? .green : quizSessionManager.quizSession.isNowPlaying ? .clear : .gray)
            .opacity(quizSessionManager.quizSession.activeQuiz ? 1 : 0)
            
            // MARK: Play Button
            Button(action: {
                isPlaying.toggle()
                quizSessionManager.startNewQuizSession(questions: injectTestQuestions())
            }) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
            .font(.largeTitle)
            .fontWeight(.black)
            
            // MARK: C Button
            Button(action: {
                quizSessionManager.selectAnswer(selectedOption: "C")
            }) {
                Text("C")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
            .foregroundStyle(quizSessionManager.quizSession.isAwaitingResponse ? .green : quizSessionManager.quizSession.isNowPlaying ? .clear : .gray)
            .opacity(quizSessionManager.quizSession.activeQuiz ? 1 : 0)
            
            // MARK: D Button
            Button(action: {
                quizSessionManager.selectAnswer(selectedOption: "D")
            }) {
                Text("D")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PlainButtonStyle())
            .font(.title)
            .foregroundStyle(quizSessionManager.quizSession.isAwaitingResponse ? .green : quizSessionManager.quizSession.isNowPlaying ? .clear : .gray)
            .opacity(quizSessionManager.quizSession.activeQuiz ? 1 : 0)
        }
    }
}

func injectTestQuestions() -> [Question] {
    // Mock implementation for test questions
    return [
        Question(id: UUID(), content: "What is the capital of France?", options: ["A", "B", "C", "D"], correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, audioScript: "", audioUrl: "")
    ]
}

//#Preview {
//    ButtonsGridView(quizSessionManager: <#QuizSessionManager#>)
//}
