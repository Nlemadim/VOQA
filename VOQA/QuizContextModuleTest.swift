//
//  QuizContextModuleTest.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/2/24.
//

import SwiftUI

struct QuizContextModuleTest: View {
    @State private var isPlaying = false
    @StateObject private var quizContext: QuizContext = QuizContext.create(state: IdleState())
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\(quizContext.countdownTime)")
                .padding(.horizontal)
            
            Text("\(quizContext.currentQuestionText)")
                .padding(.horizontal)
            
            HStack {
                Button(action: {
                    quizContext.buttonSelected = "A"
                }) {
                    Text("A")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    quizContext.buttonSelected = "A"
                }) {
                    Text("B")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    isPlaying.toggle()
                    quizContext.startQuiz()
                    quizContext.questions = self.injectTestQuestions()
                }) {
                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    quizContext.buttonSelected = "A"
                }) {
                    Text("C")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    quizContext.buttonSelected = "A"
                }) {
                    Text("D")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .font(.title)
            .padding()
        }
        .onAppear {
            quizContext.questions = injectTestQuestions()
        }
        .navigationTitle("Quiz Context Module Test")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
    
    func injectTestQuestions() -> [Question] {
        
        let questions = [
        
            Question(
                topicId: UUID(),
                content: "What is the capital of France?",
                options: ["Paris", "London", "Berlin", "Madrid"],
                correctOption: "A",
                audioScript: "New Question! What is the capital of France?",
                audioUrl: "TheDoerVoSfx",
                correctionScript: "Thats not right. The correct answer is France",
                correctionScriptUrl: "LightWork-Vosfx",
                replayQuestionAudioScript: "Absolutely! The question is: What is the capital of France?",
                replayOptionAudioScript: "Ok, The options are; Paris, London, Berlin, Madrid",
                topicCategory: TopicCategory.advanced
            ),
            
            Question(
                topicId: UUID(),
                content: "What is the capital of France?",
                options: ["Paris", "London", "Berlin", "Madrid"],
                correctOption: "B",
                audioScript: "New Question! What is the capital of France?",
                audioUrl: "TheDoerVoSfx",
                correctionScript: "Thats not right. The correct answer is France",
                correctionScriptUrl: "LightWork-Vosfx",
                replayQuestionAudioScript: "Absolutely! The question is: What is the capital of France?",
                replayOptionAudioScript: "Ok, The options are; Paris, London, Berlin, Madrid",
                topicCategory: TopicCategory.advanced
            ),
            
            Question(
                topicId: UUID(),
                content: "What is the capital of France?",
                options: ["Paris", "London", "Berlin", "Madrid"],
                correctOption: "A",
                audioScript: "New Question! What is the capital of France?",
                audioUrl: "TheDoerVoiceOver",
                correctionScript: "Thats not right. The correct answer is France",
                correctionScriptUrl: "smallVoiceOver",
                replayQuestionAudioScript: "Absolutely! The question is: What is the capital of France?",
                replayOptionAudioScript: "Ok, The options are; Paris, London, Berlin, Madrid",
                topicCategory: TopicCategory.advanced
            )
        ]
        
        return questions
    }
}



#Preview {
    QuizContextModuleTest()
}
