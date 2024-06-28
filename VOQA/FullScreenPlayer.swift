//
//  FullScreenPlayer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/25/24.
//

import SwiftUI

struct FullScreenPlayer: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    @ObservedObject internal var quizContext: QuizContext
    @State var buttonSelected: String? = ""
    
    @Binding var expandSheet: Bool
    var configuration: HomePageConfig
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 10) {
                   
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            if quizContext.countdownTime > 0 {
                                
                                VStack {
                                    Divider().activeGlow(generator.dominantLightToneColor, radius: 0.5)
                                       
                                    heroView
                                        .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                    
                                    Divider().activeGlow(generator.dominantLightToneColor, radius: 0.5)
                                    
                                    playerControlButtons
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                            } else {
                                headerSection
                                    .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                Divider().activeGlow(generator.dominantLightToneColor, radius: 0.5)
                                
                                mainViewSection
                                
                                Divider().activeGlow(generator.dominantLightToneColor, radius: 0.5)
                                playerControlButtons
                            }
                            
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                   
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { minimizeScreen() }, label: {
                            Image(systemName: "chevron.down.circle")
                                .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        })
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("VOQA")
                            .font(.title)
                            .fontWeight(.black)
                            .kerning(-0.5)
                            .primaryTextStyleForeground()
                            .opacity(quizContext.activeQuiz ? 0 : 1)
                    }
                }
                .background(generator.dominantBackgroundColor.gradient)
            }
            .sheet(isPresented: .constant(presentResponseModal()), content: {
                ResponseModalPresenter(context: quizContext, selectedOption: $buttonSelected)
                    .presentationDetents([.height(150)])
            })
            .onAppear {
               
                generator.updateAllColors(fromImageNamed: quizContext.quizTitleImage.isEmptyOrWhiteSpace ? "VoqaIcon" : quizContext.quizTitleImage)
            }
        }
    }
    
    func presentResponseModal() -> Bool {
        quizContext.isListening ? true : false
    }

    private func minimizeScreen() {
        expandSheet = false
        dismiss()
    }

    @ViewBuilder
    private var heroView: some View {
        VStack(spacing: 10) {
            Image(quizContext.quizTitleImage.isEmptyOrWhiteSpace ? "IconImage" : quizContext.quizTitleImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .frame(height: 200)
                .padding()
            
            Text(quizContext.countdownTime > 0 ? "Start" : quizContext.countdownTime < 2 ? "Here we go!" : "Get Ready!" )
                .font(.title3)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                .padding(.top, 2)
            
            Text("\(Int(quizContext.countdownTime))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                .padding(.top, 2)
                .opacity(quizContext.activeQuiz ? 1 : 0)
        }
        .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
        .padding()
        .frame(width: 380, height: 180)
        .frame(maxWidth: 380)
        .padding(.horizontal, 3)
        .padding(.bottom, 15)
    }

    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 10) {
            HStack {
                Image(quizContext.quizTitleImage.isEmptyOrWhiteSpace ? "IconImage" : quizContext.quizTitleImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .frame(height: 100)

                VStack(alignment: .leading) {
                    Text(quizContext.quizTitle)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .padding(.top, 2)
                    
                    Text("Audio Quiz")
                        .font(.subheadline)
                        .padding(.top, 2)
                        .foregroundStyle(.primary)
                    
                    ZStack {
                        Text("\(quizContext.questionCounter)")
                            .font(.subheadline)
                            .padding(.top, 2)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(height: 100)
                Spacer()
            }
            
            ZStack {
                // Add your wave views here and manage their visibility with quizContext properties
                // Example:
                // VoqaWaveView(colors: [...], isSpeaking: quizContext.isSpeaking)
            }
        }
        .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
        .padding()
        .frame(width: 380, height: 180)
        .frame(maxWidth: 380)
        .padding(.horizontal, 3)
        .padding(.bottom, 15)
    }

    @ViewBuilder
    private var mainViewSection: some View {
        VStack {
            Text(quizContext.currentQuestionText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                .padding()
        }
    }

    @ViewBuilder
    private var playerControlButtons: some View {
        PlayerControlButtons(
            quizContext: quizContext,
            questionsComplete: $quizContext.isLastQuestion,
            themeColor: generator.enhancedDominantColor,
            recordAction: {
                
            },
            playAction: {
                
                DispatchQueue.main.async {
                    print("Pressed play")
                    self.quizContext.startQuiz()
//                    if quizContext.activeQuiz {
//                        
//                        quizContext.questionPlayer.pausePlayback()
//                        
//                    } else {
//                        
//                        quizContext.questionPlayer.playQuestions(quizContext.questions, in: quizContext)
//                    }
                }
            },
            nextAction: {
                
            }
        )
        .hAlign(.center)
    }

}





struct TranscriptView: View {
    @Binding var questionTranscript: String
    var color: Color
    @State private var timer: Timer?
    @State private var feedBackImage: String = ""
    @State private var showImageFeedback: Bool = false
    @State private var showTextFeedback: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image(systemName: "IconImage")
                    .resizable()
                    .foregroundStyle(color)
                    .frame(width: 80, height: 80)
                    .padding()
            }
            .opacity(showImageFeedback ? 1 : 0)
            
            VStack {
                Text(questionTranscript)
                    .font(.title2)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .kerning(0.3)
                    .foregroundStyle(color)
                    .offset(y: -50)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onAppear {
                        startTypingAnimation(for: questionTranscript)
                    }
            }
            .frame(maxHeight: .infinity)
            .opacity(showTextFeedback ? 1 : 0)
            
        }
    }
    
    
    private func startTypingAnimation(for text: String) {
        var displayedText = ""
        var messageIndex = 0
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if messageIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: messageIndex)
                displayedText += String(text[index])
                messageIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}



struct PlayerControlButtons: View {
    @ObservedObject var quizContext: QuizContext
    @Binding var questionsComplete: Bool
    let isHandsfree = false/*UserDefaultsManager.isHandfreeEnabled()*/

    var themeColor: Color?
    var recordAction: () -> Void
    var playAction: () -> Void
    var nextAction: () -> Void
  
    var body: some View {
        VStack(spacing: 5) {
            
            HStack(spacing: 30) {
                Spacer()
                // Repeat Button
//                CircularButton(
//                    isPlaying: .constant(false),
//                    isDownloading: .constant(false),
//                    imageLabel: isHandsfree ? "mic" : "abc",
//                    color: themeColor ?? .clear,
//                    buttonAction: { recordAction() })
//"rectangle.and.hand.point.up.left.fill"
                
                
                
                CircularPlayButton(quizContext: quizContext, isDownloading: .constant(false), color: themeColor ?? .clear, playAction: { playAction()})
                
                Spacer()
                // Next/End Button
//                CircularButton(
//                    isPlaying: .constant(false),
//                    isDownloading: .constant(false),
//                    imageLabel: questionsComplete ? "forward.end.fill" :"forward.fill" ,
//                    color: themeColor ?? .clear,
//                    buttonAction: { nextAction() })
//                .disabled(questionsComplete)
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            
        }
    }
}



struct ImageLoadingView: View {
    var image: Image
    
    @State private var bobbingOffset: CGFloat = 0.0
    
    var body: some View {
        VStack(spacing: 20) { // Add spacing between the bobbing image and the text
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .frame(height: 100)
                .offset(y: bobbingOffset)
//                .animation(
//                    interactionState == .isDownloading ?
//                    Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default,
//                    value: interactionState
//                )
//                .opacity(interactionState == .isDownloading ? 1 : 0)
//                .onAppear {
//                    if interactionState == .isDownloading {
//                        startBobbing()
//                    }
//                }
//                .onChange(of: interactionState) {_, newState in
//                    if newState == .isDownloading {
//                        startBobbing()
//                    } else {
//                        stopBobbing()
//                    }
//                }
            
            Text("Loading...")
                .font(.headline)
                .bold()
               // .opacity(interactionState == .isDownloading ? 1 : 0)
        }
    }
    
    private func startBobbing() {
        withAnimation {
            bobbingOffset = -10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation {
                bobbingOffset = 10
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            startBobbing()
        }
    }
    
    private func stopBobbing() {
        withAnimation {
            bobbingOffset = 0
        }
    }
}

struct EmptyCollectionView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray.and.arrow.down.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .frame(height: 50)
            
            Text("Questions Collection Is Empty")
                .font(.title3)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .kerning(0.3)
        }
    }
}

struct QuestionTranscriptView: View {
    var questionTranscript: String

    var body: some View {
        Text(questionTranscript)
            .fontWeight(.black)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .kerning(0.3)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }
}



//#Preview {
//    FullScreenPlayer(quizContext: <#QuizContext#>, expandSheet: <#Binding<Bool>#>)
//}
