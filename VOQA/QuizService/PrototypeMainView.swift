//
//  PrototypeMainView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/6/24.
//

import SwiftUI

//struct PrototypeMainView: View {
//    @StateObject private var quizSessionManager = QuizSessionManager(state: IdleSession())
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                GeometryReader { geometry in
//                    VStack {
//                        Image("VoqaIcon")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .offset(x: getCurrentOffset().x, y: getCurrentOffset().y)
//                            .animation(.easeInOut(duration: 2.0), value: quizSessionManager.currentQuestionText)
//                            .offset(y: -60)
//                    }
//                }
//
//                VStack {
//                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
//                        .fill(Material.ultraThin)
//                        .frame(width: 350, height: 550)
//                        .padding(.bottom, 50)
//                        .transition(.move(edge: .bottom))
//                        .overlay {
//                            VStack {
//                                Text(quizSessionManager.currentQuestionText)
//                                    .padding()
//                                    .offset(y: -10)
//                                // Any other content related to the question
//                            }
//                        }
//                    
//                    // Add ButtonGridView here
//                    ButtonsGridView(quizSessionManager: quizSessionManager)
//                }
//                .font(.title)
//                .padding()
//                .animation(.easeInOut(duration: 2.0), value: quizSessionManager.currentQuestionText)
//            }
//            .navigationTitle(quizSessionManager.questionCounter)
//            .navigationBarTitleDisplayMode(.large)
//        }
//    }
//    
//    private func getCurrentOffset() -> CGPoint {
//        let offsets: [CGPoint] = [
//            .zero,
//            CGPoint(x: 350, y: -250),
//            CGPoint(x: -350, y: 250),
//            CGPoint(x: 300, y: 200),
//            CGPoint(x: -300, y: -200)
//        ]
//        
//        return offsets.randomElement() ?? .zero
//    }
//}
//
//
//#Preview {
//    PrototypeMainView()
//}
