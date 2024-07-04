//
//  ResponseModalPresenter.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct ResponseModalPresenter: View {
    @ObservedObject var context: QuizContext
    @Binding var selectedOption: String?
    
    @State private var mainColor: Color = .black
    @State private var subColor: Color = .gray
    @StateObject private var generator = ColorGenerator()
    
    var body: some View {
        VStack {
            Spacer()
            if context.state is ListeningState {
                MicModalView(context: context, mainColor: mainColor, subColor: subColor)
            } else if context.state is AwaitingResponseState {
                OptionButtonsModalView(selectedOption: $selectedOption, mainThemeColor: mainColor, selectionThemeColor: subColor)
            }
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
        .onAppear {
            DispatchQueue.main.async {
                updateViewColors()
            }
        }
    }
    
    func updateViewColors() {
        generator.updateAllColors(fromImageNamed: "IconImage")
        self.mainColor = generator.dominantBackgroundColor
        self.subColor = generator.dominantLightToneColor
    }
}

struct MicModalView: View {
    @ObservedObject var context: QuizContext
    @State private var timerCountdown: Int = 5
    @State private var isTimerActive: Bool = true
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                MicButtonWithProgressRing(showProgressRing: context.isListening)
                    .padding()
            }
            .padding(20)
            .padding(.horizontal)
            
            Text("Listening... \(timerCountdown)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(mainColor.dynamicTextColor())
        
            Spacer()
        }
        .onAppear {
            startCountdown()
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.linear(duration: 1)) {
                if self.timerCountdown > 0 {
                    self.timerCountdown -= 1
                } else {
                    timer.invalidate()
                    self.isTimerActive = false
                }
            }
        }
    }
}



//#Preview {
//    ResponseModalPresenter(interactionState: .constant(.awaitingResponse), selectedOption: .constant(""), mainColor: .teal, subColor: .themePurple)
//}


struct MicButtonWithProgressRing: View {
    @State private var fillAmount: CGFloat = 0.0
    @State var showProgressRing: Bool
    @State var resetTimer: Bool = false

    let imageSize: CGFloat = 25 // Adjusted size

    var body: some View {
        ZStack {
            // Background
            Circle()
                .fill(Color.themePurple)
                .frame(width: imageSize * 3, height: imageSize * 3)

            // Conditional display of Progress Ring
            if showProgressRing {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 5)
                    .frame(width: imageSize * 3, height: imageSize * 3)

                Circle()
                    .trim(from: 0, to: fillAmount)
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: imageSize * 3, height: imageSize * 3)
                    .rotationEffect(.degrees(-270))
                    .animation(.linear(duration: 5), value: fillAmount)
            }

            // Mic Button
            Button(action: {
                self.startFilling()
            }) {
                Image(systemName: "mic.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .symbolEffect(.pulse, options: .repeating, isActive: showProgressRing)
            }
        }
        .onAppear { startFilling() }
    }

    private func startFilling() {
        fillAmount = 0.0 // Reset the fill amount
        showProgressRing = true // Show the progress ring
        resetTimer = true

        // Animate the fill amount to gradually increase over 6 seconds
        //MARK: TODO - USE GLOBAL LISTENING TIME TO SET MIC FILL ANIMATION
        withAnimation(.linear(duration: 5)) {
            fillAmount = 1.0 // Fill the ring over 5 seconds
        }

        // Hide the progress ring and reset other states after 6 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showProgressRing = false
            self.resetTimer = false
        }
    }
}


struct OptionButtonsModalView: View {
    @Binding var selectedOption: String?
    @State private var timerCountdown: Int = 5
    @State private var isTimerActive: Bool = true
    @State private var isSelectionMade: Bool = false
    @State private var progressText: String = "Tap and hold to select"
    var mainThemeColor: Color
    var selectionThemeColor: Color = .themePurple
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                MultiChoiceButton(label: "A", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
                MultiChoiceButton(label: "B", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
                MultiChoiceButton(label: "C", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
                MultiChoiceButton(label: "D", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
            }
            .padding()
            .padding(.horizontal)
            .offset(y: -10)
            
            VStack(alignment: .center) {
                Text("Tap to select... \(timerCountdown)")
                     .font(.subheadline)
                     .fontWeight(.semibold)
                     .foregroundStyle(mainThemeColor.dynamicTextColor())
                     .padding(.bottom)
            }
            
            Spacer()
        }
        .onAppear {
            startCountdown()
            print(selectedOption as Any)
        }
        .onChange(of: selectedOption) { _, newSelectedOption in
            displaySelection(newSelectedOption)
        }
    }
    
    private func displaySelection(_ selectedOption: String?) {
        guard selectedOption != nil else { return }
        if let selectedOption, !selectedOption.isEmptyOrWhiteSpace {
            DispatchQueue.main.async {
                self.progressText = selectedOption
                print(selectedOption)
            }
        }
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.linear(duration: 1)) {
                if self.timerCountdown > 0 {
                    self.timerCountdown -= 1
                } else {
                    timer.invalidate()
                    self.isTimerActive = false
                    if !self.isSelectionMade {
                        self.selectedOption = ""
                    }
                }
            }
        }
    }
}


struct MultiChoiceButton: View {
    //@GestureState private var isLongPressing: Bool = false
    let label: String
    @Binding var selectedOption: String?
    @Binding var isSelectionMade: Bool
    @Binding var isTimerActive: Bool
    @Binding var timerCountdown: Int
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: {
            self.startFilling()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.selectOption()
            }
        }) {
            ZStack {
                Circle()
                    .fill(isTimerActive ? .themePurple : (isSelectionMade && selectedOption == label ? .teal : .gray))
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
        .disabled(!isTimerActive || isSelectionMade)
    }
    
    private func startFilling() {
        if !isTimerActive || isSelectionMade { return }
        
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
            isTimerActive = false
            timerCountdown = 0 // Invalidate the timer immediately
            provideHapticFeedback()
            print(selectedOption as Any)
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

