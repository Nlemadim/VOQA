//
//  VoqaSpeechVisualizer.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//


import Foundation
import SwiftUI
import Combine


struct VoqaSpeechVisualizer: View {
    @Binding var switchOn: Bool
    @State private var voqaWave: VoqaWave
    @State private var power: Double = 0.0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.3, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?

    var colors: [Color]
    var supportLineColor: Color
    
    init(colors: [Color], supportLineColor: Color = .white, switchOn: Binding<Bool>) {
        self._switchOn = switchOn
        self._voqaWave = State(initialValue: VoqaWave(numWaves: colors.count, power: 0.0))
        self.colors = colors
        self.supportLineColor = supportLineColor
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
        .onAppear {
            voqaWave = VoqaWave(numWaves: colors.count, power: power)
            //toggleTimerBasedOnSwitch()
        }
        .onChange(of: switchOn) {_, _ in
            print("Visualizer is on: \(switchOn)")
            toggleTimerBasedOnSwitch()
        }
        .onReceive(timer) { _ in
            updatePowerRandomly()
        }
    }
    
    private func toggleTimerBasedOnSwitch() {
        if switchOn {
            // Start or continue the timer
            if timerCancellable == nil {
                timerCancellable = timer.connect()
            }
        } else {
            // Stop the timer when switch is off
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
