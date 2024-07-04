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
        
        let questions: [Question] = []
        
        return questions
    }
}



#Preview {
    QuizContextModuleTest()
}
