//
//  QuizControlButtonsGrid.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI

struct QuizControlButtonsGrid: View {
    @Binding var awaitingResponse: Bool
    @State private var hasStarted: Bool = false
    @State private var selectedOption: String? = nil
    var selectButton: (String) -> Void
    var centralAction: () -> Void
    
    @State private var buttonColors: [Color] = [.gray, .gray, .gray, .gray]

    var body: some View {
        HStack {
            MultiChoiceButton(label: "A", selectedOption: $selectedOption, awaitingResponse: $awaitingResponse, color: buttonColors[0], action: {
                selectButton("A")
            })
            
            MultiChoiceButton(label: "B", selectedOption: $selectedOption, awaitingResponse: $awaitingResponse, color: buttonColors[1], action: {
                selectButton("B")
            })
            
//            CircularPlayButton(quizContext: <#QuizSession#>, isDownloading: .constant(false), color: .white, playAction: {
//                awaitingResponse = true
//                centralAction()
//            })
            
            MultiChoiceButton(label: "C", selectedOption: $selectedOption, awaitingResponse: $awaitingResponse, color: buttonColors[2], action: {
                selectButton("C")
            })
            
            MultiChoiceButton(label: "D", selectedOption: $selectedOption, awaitingResponse: $awaitingResponse, color: buttonColors[3], action: {
                selectButton("D")
            })
        }
        .onChange(of: self.awaitingResponse) { _, isAwaiting in
            if isAwaiting {
                generateUniqueColors()
            } else {
                self.selectedOption = nil
            }
        }
        .padding(.horizontal)
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
    @Binding var awaitingResponse: Bool
    var color: Color
    var action: () -> Void
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false

    var body: some View {
        Button(action: {
            self.startFilling()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.selectOption()
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
            .padding(5)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!awaitingResponse)
    }
    
    private func startFilling() {
        if !awaitingResponse || selectedOption != nil { return }
        
        fillAmount = 0.0
        showProgressRing = true
        
        withAnimation(.linear(duration: 1)) {
            fillAmount = 1.0
        }
    }
    
    private func selectOption() {
        if fillAmount >= 1.0 {
            selectedOption = label
            awaitingResponse = false
            action()
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



enum ProgressViewDisplayMode {
    case quickLoad
    case awaitLoading(Binding<Bool>)
}

struct CircularPlayButton2: View {
    @State private var showProgressView = false
    var color: Color
    var label: String
    var progressMode: ProgressViewDisplayMode
    var action: () -> Void

    var body: some View {
        Button(action: buttonAction) {
            if showProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 23, height: 23)  // Adjusted for 2/3 size
            } else {
                Text(label)
                    .foregroundColor(.white)
                    .frame(width: 47, height: 47)  // Adjusted for 2/3 size
                    .background(color)
                    .cornerRadius(23.5)  // Adjusted for 2/3 size
            }
        }
        .frame(width: 47, height: 47)  // Adjusted for 2/3 size
        .foregroundStyle(color)
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 1)
        )
        .disabled(showProgressView && isAwaitLoadingMode())
    }

    private func buttonAction() {
        switch progressMode {
        case .quickLoad:
            showProgressView = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showProgressView = false
            }
        case .awaitLoading(let isLoading):
            showProgressView = true
            action()
            isLoading.wrappedValue = true
        }
    }
    
    private func isAwaitLoadingMode() -> Bool {
        if case .awaitLoading = progressMode {
            return true
        }
        return false
    }
}



