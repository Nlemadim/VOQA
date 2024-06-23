//
//  VoqaWaveView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI
import Combine

struct VoqaWaveView: View {
    @ObservedObject var quizContext: QuizContext
    @State private var voqaWave: VoqaWave
    @State private var power: Double = 0.0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.3, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?

    var colors: [Color]
    var supportLineColor: Color
    
    init(colors: [Color], supportLineColor: Color = .white, quizContext: QuizContext) {
        self._voqaWave = State(initialValue: VoqaWave(numWaves: colors.count, power: 0.0))
        self.colors = colors
        self.supportLineColor = supportLineColor
        self.quizContext = quizContext
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Support line at the back
                SupportLine(color: supportLineColor)
                
                // Dynamic wave views for each color
                ForEach(Array(zip(voqaWave.waves.indices, voqaWave.waves)), id: \.0) { index, wave in
                    WaveView(wave: wave, color: colors[index % colors.count])
                        .animation(.linear(duration: 0.2), value: power)
                }
            }
            .blendMode(.lighten)
            .drawingGroup()
        }
        .onChange(of: quizContext.audioPlayer?.isPlaying) {_, _ in
            voqaWave = VoqaWave(numWaves: colors.count, power: power)
            toggleTimerBasedOnAudioPlayerState()
        }
        .onReceive(timer) { _ in
            updatePowerRandomly()
        }
        .onDisappear {
            timerCancellable?.cancel()
        }
    }
    
    private func toggleTimerBasedOnAudioPlayerState() {
        if quizContext.audioPlayer?.isPlaying == true {
            // Start or continue the timer
            if timerCancellable == nil {
                timerCancellable = timer.connect()
            }
        } else {
            // Stop the timer when not playing
            timerCancellable?.cancel()
            timerCancellable = nil
        }
    }
    
    private func updatePowerRandomly() {
        withAnimation {
            power = Double.random(in: 0.0...2.0)
            voqaWave = VoqaWave(numWaves: colors.count, power: power)
        }
    }
}



//#Preview {
//    VoqaWaveView(colors: [.red, .green, .blue], supportLineColor: .white, quizContext: MockQuizContext())
//        .preferredColorScheme(.dark)
//}

//#Preview {
//    VoqaWaveView(colors: <#[Color]#>, quizContext: <#QuizContext#>)
//}
