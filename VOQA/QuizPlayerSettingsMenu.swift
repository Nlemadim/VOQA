//
//  QuizPlayerSettingsMenu.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct QuizPlayerSettingsMenu: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    @State private var isQandA: Bool = UserDefaultsManager.isQandAEnabled()
    @State private var numberOfQuestions: Int = UserDefaultsManager.numberOfTestQuestions()
    @State private var isMicrophoneOn: Bool = UserDefaultsManager.isHandfreeEnabled()
    @State private var autoRestart: Bool = UserDefaultsManager.isContinousPlayEnabled()
    @State private var isStandardQuiz: Bool = false
    @State private var isButtonTapMode: Bool = true
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .clear,.themePurple.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .center) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .frame(height: 280)
                .blur(radius: 60)
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 10) {
                        
                        CustomSection(header: "Number of Questions") {
                            //MARK: Number of Questions Stepper
                            NumberOfQuestionsStepper(numberOfQuestions: $numberOfQuestions)
                        }
                        
                        CustomSection(header: "Modes") {
                            
                            //MARK: IsStandardQuiz Toggle (Changes isQandAEnabled to false)
                            ToggleRow(label: "Standard Quiz", systemImage: "alarm.fill", isOn: $isStandardQuiz) {_ in
                                
                            }
                            //MARK: isQandAEnabled Toggle (Changes isQandAEnabled)
                            ToggleRow(label: "Q&A", systemImage: "book.fill", isOn: $isQandA) {_ in
                            }
                        }
                        
                        CustomSection(header: "Input Methods") {
                            
                            //MARK: isButtonTapMode Toggle (Changes isMicrophoneOn to false)
                            ToggleRow(label: "Buttons", systemImage: "rectangle.and.hand.point.up.left.fill", isOn: $isButtonTapMode) {_ in
                            }
                            
                            //MARK: isMicrophoneOn Toggle (Changes isButtonTapMode)
                            ToggleRow(label: "Mic", systemImage: "mic.fill", isOn: $isMicrophoneOn) {_ in
                            }
                        }
                        
                        CustomSection(header: "Playback") {
                            ToggleRow(label: "Auto restart", systemImage: "repeat", isOn: $autoRestart) {
                                UserDefaultsManager.enableContinousPlay($0)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .onAppear {
                        setQuizMode(self.isQandA)
                        setHandsfreeMode(self.isMicrophoneOn)
                    }
                    .onChange(of: isQandA) { _, newValue in
                        setQuizMode(newValue)
                        updateToggleView()
                        UserDefaultsManager.enableQandA(newValue)
                    }
                    .onChange(of: isMicrophoneOn) { _, newValue in
                        setHandsfreeMode(newValue)
                        UserDefaultsManager.enableHandsfree(newValue)
                    }
                    .onChange(of: isStandardQuiz) { _, _ in
                        updateToggleView()
                    }
                    .onChange(of: isButtonTapMode) { _, _ in
                        updateToggleView()
                    }
        
                }
            }
            .foregroundStyle(.white)
        }
    }
    
    private func updateToggleView() {
        DispatchQueue.main.async {
            if self.isButtonTapMode == true {
                self.isMicrophoneOn = false
            }
            
            if self.isButtonTapMode == false {
                self.isMicrophoneOn = true
            }
            
            if self.isStandardQuiz == true {
                self.isQandA = false
            }
            
            if self.isStandardQuiz == false {
                self.isQandA = true
            }
            
        }
    }
    
    private func setQuizMode(_ isQandA: Bool) {
        DispatchQueue.main.async {
            if isQandA {
                self.isStandardQuiz = false
            } else {
                self.isStandardQuiz = true
            }
        }
    }
    
    private func setHandsfreeMode(_ isMicOn: Bool) {
        DispatchQueue.main.async {
            if isMicOn {
                self.isButtonTapMode = false
            } else {
                self.isButtonTapMode = true
            }
        }
    }
}


#Preview {
    QuizPlayerSettingsMenu()
        .preferredColorScheme(.dark)
}


struct ToggleRow: View {
    let label: String
    let systemImage: String
    @Binding var isOn: Bool
    let userDefaultsUpdate: (Bool) -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: systemImage)
                Text(label)
                    .font(.subheadline)
            }
            Spacer()
            CustomToggle(isOn: $isOn, onColor: .mint, offColor: .gray.opacity(0.6))
                .onChange(of: isOn) {_, newValue in
                    userDefaultsUpdate(newValue)
                }
        }
        
    }
}

struct CustomSection<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(header)
                .font(.subheadline)
                .padding(.bottom, 5)
            
            content
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Material.ultraThin))
        }
        .padding(.vertical, 5)
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    let onColor: Color
    let offColor: Color
    
    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .fill(isOn ? onColor : offColor)
                .frame(width: 50, height: 25)
                .offset(x: -2)
            Circle()
                .fill(Color.white)
                .frame(width: 30, height: 30)
                .padding(.horizontal, 3)
                .shadow(radius: 2)
        }
        .onTapGesture {
            withAnimation {
                isOn.toggle()
            }
        }
    }
}
