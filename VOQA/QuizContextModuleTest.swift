//
//  QuizContextModuleTest.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/2/24.
//

import SwiftUI

struct QuizContextModuleTest: View {
    @State private var isPlaying = false
    @StateObject private var quizContext: QuizSession = QuizSession.create(state: IdleSession())
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Quiz Session: \(quizContext.questionCounter)")
                .padding(.horizontal)
                .font(.title)
            
            Text("Quiz Session: \(quizContext.currentQuestionText)")
                .padding(.horizontal)
                .font(.title)
            
            Text("\(quizContext.countdownTime)")
                .padding(.horizontal)
            
           Spacer()
            
            HStack {
                //MARK: A Button
                Button(action: {
                    quizContext.selectAnswer(selectedOption: "A")
                }) {
                    Text("A")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.title)
                .foregroundStyle(quizContext.isAwaitingResponse ? .green : quizContext.isNowPlaying ? .clear : .gray)
                .opacity(quizContext.activeQuiz ? 1 : 0)
                
                //MARK: B Buttom
                Button(action: {
                    quizContext.selectAnswer(selectedOption: "B")
                }) {
                    Text("B")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.title)
                .foregroundStyle(quizContext.isAwaitingResponse ? .green : quizContext.isNowPlaying ? .clear : .gray)
                .opacity(quizContext.activeQuiz ? 1 : 0)
                
                //MARK: Play Button
                Button(action: {
                    isPlaying.toggle()
//                    quizContext.sessionAudioPlayer.performAudioAction(.playQuestion(url: "smallVoiceOver"))
                    quizContext.startNewQuizSession(questions: injectTestQuestions())
                   // quizContext.questions = self.injectTestQuestions()
                }) {
                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.largeTitle)
                .fontWeight(.black)
               
                
                //MARK: C Button
                Button(action: {
                    quizContext.selectAnswer(selectedOption: "C")
                }) {
                    Text("C")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.title)
                .foregroundStyle(quizContext.isAwaitingResponse ? .green : quizContext.isNowPlaying ? .clear : .gray)
                .opacity(quizContext.activeQuiz ? 1 : 0)
                
                //MARK: D Button
                Button(action: {
                    quizContext.selectAnswer(selectedOption: "D")
                }) {
                    Text("D")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .font(.title)
                .foregroundStyle(quizContext.isAwaitingResponse ? .green : quizContext.isNowPlaying ? .clear : .gray)
                .opacity(quizContext.activeQuiz ? 1 : 0)
            }
            
            .padding()
        }
        .navigationTitle("Quiz Context Module Test")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
    
    func injectTestQuestions() -> [Question] {
        return mockQuestions
    }
    
    let mockQuestions: [Question] = [
//        Question(
//            id: UUID(),
//            content: "What is the capital of France?",
//            options: ["A: Berlin", "B: London", "C: Paris", "D: Rome"],
//            correctOption: "C",
//            selectedOption: "",
//            isAnsweredCorrectly: false,
//            numberOfPresentations: 0,
//            audioScript: "What is the capital of France?",
//            audioUrl: "liberation-VoFx"
//        ),
        
        Question(
            id: UUID(),
            content: "What is 2 + 2?",
            options: ["A: 3", "B: 4", "C: 5", "D: 6"],
            correctOption: "B",
            selectedOption: "",
            isAnswered: false,
            isAnsweredCorrectly: false,
            numberOfPresentations: 0,
            audioScript: "What is 2 plus 2?",
            audioUrl: "smallVoiceOver"
        ),
        
        Question(
            id: UUID(),
            content: "Which planet is known as the Red Planet?",
            options: ["A: Earth", "B: Mars", "C: Jupiter", "D: Saturn"],
            correctOption: "B",
            selectedOption: "",
            isAnswered: false,
            isAnsweredCorrectly: false,
            numberOfPresentations: 0,
            audioScript: "Which planet is known as the Red Planet?",
            audioUrl: "smallVoiceOver2"
        )
        
        
        
//        Question(
//            id: UUID(),
//            content: "Who wrote 'To Kill a Mockingbird'?",
//            options: ["A: Harper Lee", "B: Mark Twain", "C: J.K. Rowling", "D: Ernest Hemingway"],
//            correctOption: "A",
//            selectedOption: "",
//            isAnsweredCorrectly: false,
//            numberOfPresentations: 0,
//            audioScript: "Who wrote 'To Kill a Mockingbird'?",
//            audioUrl: "LightWork-Vosfx"
//        )
    ]
}



#Preview {
    QuizContextModuleTest()
}
