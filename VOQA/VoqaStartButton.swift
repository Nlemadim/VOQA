//
//  VoqaStartButton.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/25/24.
//

import SwiftUI

struct VoqaStartButton: View {
    @ObservedObject var quizContext: QuizContext
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    @State private var resetTimer: Bool = false
    @State private var press: Bool = false
    @GestureState private var tap = false
    
    let buttonSize: CGFloat = 75 // Adjusted size to match MicButtonWithProgressRing
    
    var body: some View {
        ZStack {
            if quizContext.isListening {
                listeningView
            } else if quizContext.isPlaying {
                playingView
            } else {
                idleView
            }
        }
        .frame(width: buttonSize * 3, height: buttonSize * 3)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(press ? .themePurple : .themeTeal), Color(press ? .themePurple : .themeTeal)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Circle()
                    .stroke(Color.clear, lineWidth: 10)
                    .shadow(color: Color(press ? .themePurple : .themeTeal), radius: 3, x: -5, y: -5)
                
                Circle()
                    .stroke(Color.clear, lineWidth: 10)
                    .shadow(color: Color(press ? .themePurple : .themeTeal), radius: 3, x: 3, y: 3)
            }
                .clipShape(Circle())
                .shadow(color: Color(press ? .themeTeal : .themePurple), radius: 20, x: -20, y: -20)
                .shadow(color: Color(press ? .themePurple : .themeTeal), radius: 20, x: 20, y: 20)
                .scaleEffect(tap ? 1.2 : 1)
                .gesture(
                    LongPressGesture().updating($tap) { currentState, gestureState, transaction in
                        gestureState = currentState
                    }.onEnded { value in
                        self.press.toggle()
                    }
                )
        )
    }
    
    @ViewBuilder
    private var idleView: some View {
        Text("START")
            .font(.system(size: 44, weight: .bold))
            .foregroundColor(.white)
            .kerning(0.5)
            .textCase(.uppercase)
            .rotation3DEffect(Angle(degrees: press ? 0 : 20), axis: (x: 10, y: -10, z: 0))
            .onTapGesture {
                // Start the quiz or whatever action is needed
                quizContext.startQuiz()
            }
    }
    
    @ViewBuilder
    private var playingView: some View {
        Image(systemName: "pause.fill")
            .font(.system(size: 44, weight: .bold))
            .foregroundColor(.white)
            .rotation3DEffect(Angle(degrees: press ? 0 : 20), axis: (x: 10, y: -10, z: 0))
            .onTapGesture {
                //quizContext.audioPlayer?.pausePlayback()
            }
    }
    
    @ViewBuilder
    private var listeningView: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 5)
                .frame(width: buttonSize * 3, height: buttonSize * 3)
            
            Circle()
                .trim(from: 0, to: fillAmount)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: buttonSize * 3, height: buttonSize * 3)
                .rotationEffect(.degrees(-270))
                .animation(.linear(duration: 5), value: fillAmount)
            
            Image(systemName: "mic.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
                .symbolEffect(.pulse, options: .repeating, isActive: showProgressRing)
        }
        .onAppear { startFilling() }
    }
    
    private func startFilling() {
        fillAmount = 0.0 // Reset the fill amount
        showProgressRing = true // Show the progress ring
        resetTimer = true

        // Animate the fill amount to gradually increase over 5 seconds
        withAnimation(.linear(duration: 5)) {
            fillAmount = 1.0 // Fill the ring over 5 seconds
        }

        // Hide the progress ring and reset other states after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showProgressRing = false
            self.resetTimer = false
        }
    }
}

//#Preview {
//    VoqaStartButton()
//}
