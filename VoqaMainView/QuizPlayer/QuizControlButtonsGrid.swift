//
//  QuizControlButtonsGrid.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

struct QuizControlButtonsGrid: View {
    @State private var awaitingResponse: Bool = false {
        didSet {
            if awaitingResponse {
                generateUniqueColors()
            }
        }
    }
    @State private var hasStarted: Bool = false
    @State private var selectedOption: String? = nil
    var selectButton: (String) -> Void
    var centralAction: () -> Void
    
    @State private var buttonColors: [Color] = [.gray, .gray, .gray, .gray]

    var body: some View {
        HStack {
            MultiChoiceButton(label: "A", selectedOption: $selectedOption, isSelectionMade: .constant(false), awaitingResponse: $awaitingResponse, timerCountdown: .constant(5), color: buttonColors[0])
                //.transition(.move(edge: .leading))
            
            MultiChoiceButton(label: "B", selectedOption: $selectedOption, isSelectionMade: .constant(false), awaitingResponse: $awaitingResponse, timerCountdown: .constant(5), color: buttonColors[1])
                //.transition(.move(edge: .leading))
            
            CircularPlayButton(isDownloading: .constant(false), isNowPlaying: false, color: .white, playAction: {
                awaitingResponse = true
                centralAction()
            })
            
            MultiChoiceButton(label: "C", selectedOption: $selectedOption, isSelectionMade: .constant(false), awaitingResponse: $awaitingResponse, timerCountdown: .constant(5), color: buttonColors[2])
                //.transition(.move(edge: .trailing))
            
            MultiChoiceButton(label: "D", selectedOption: $selectedOption, isSelectionMade: .constant(false), awaitingResponse: $awaitingResponse, timerCountdown: .constant(5), color: buttonColors[3])

        }
        .padding()
    }
    
    
    
    private func generateUniqueColors() {
        var newColors: [Color] = []
        let availableColors: [Color] = [.red, .green, .blue, .yellow, .orange, .pink, .purple]
        
        while newColors.count < 4 {
            let randomColor = availableColors.randomElement()!
            if !newColors.contains(randomColor) {
                newColors.append(randomColor)
            }
        }
        
        // Ensure new colors are different from the last set
        if newColors == buttonColors {
            generateUniqueColors()
        } else {
            buttonColors = newColors
        }
    }
}

struct StopQuizButton: View {
    var stopAction: () -> Void
    
    var body: some View {
        Button(action: {
            stopAction()
            
        }) {
            Image(systemName: "stop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.red).opacity(0.7)
        }
    }
}

struct MultiChoiceButton: View {
    let label: String
    @Binding var selectedOption: String?
    @Binding var isSelectionMade: Bool
    @Binding var awaitingResponse: Bool
    @Binding var timerCountdown: Int
    var color: Color
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false

    var body: some View {
        Button(action: {
            self.startFilling()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.selectOption()
                self.awaitingResponse = false
            }
        }) {
            ZStack {
                Circle()
                    .fill(awaitingResponse ? color : .gray)
                    .frame(width: 55, height: 55)
                
                if showProgressRing {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 5)
                        .frame(width: 55, height: 55)
                    
                    Circle()
                        .trim(from: 0, to: fillAmount)
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 55, height: 55)
                        .rotationEffect(.degrees(-270))
                        .animation(.linear(duration: 1), value: fillAmount)
                }
                
                Text(label)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.white)
            }
            .padding(10)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!awaitingResponse || isSelectionMade)
    }
    
    private func startFilling() {
        if !awaitingResponse || isSelectionMade { return }
        
        fillAmount = 0.0
        showProgressRing = true
        
        withAnimation(.linear(duration: 1)) {
            fillAmount = 1.0
        }
    }
    
    private func selectOption() {
        if fillAmount >= 1.0 {
            selectedOption = label
            isSelectionMade = true
            awaitingResponse = false
            timerCountdown = 0 // Invalidate the timer immediately
            provideHapticFeedback()
        }
        resetButton()
    }
    
    private func resetButton() {
        showProgressRing = false
        fillAmount = 0.0
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct CircularPlayButton: View {
    @Binding var isDownloading: Bool
    @State var isNowPlaying: Bool = false
    var imageLabel: String?
    var color: Color
    var playAction: () -> Void
    
    var body: some View {
        Button(action: {
            self.isNowPlaying.toggle()
            playAction()
        }) {
            if isDownloading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text(isNowPlaying ? "Start" : "Play")
                    .foregroundColor(.black)
                    .frame(width: 70, height: 70)
                    .background(color)
                    .cornerRadius(40)
            }
        }
        .frame(width: 70, height: 70)
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 1)
        )
        .disabled(isDownloading)
    }
}


