//
//  VoqaWave.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import Foundation
import SwiftUI

class VoqaWave: ObservableObject {
    
    struct Curve: Equatable {
        var power: Double
        var A: Double
        var k: Double
        var t: Double
        
        static func random(withPower power: Double) -> Curve {
            
            return Curve(
                power: power,
                A: Double.random(in: 0.1...1.0),
                k: Double.random(in: 0.6...0.9),
                t: Double.random(in: -1.0...4.0)
            )
        }
    }
    
    struct Wave: Equatable {
        var power: Double
        var curves: [Curve]
        var useCurves: Int
        
        static func random(withPower power: Double) -> Wave {
            
            let numCurves = Int.random(in: 2 ... 4)
            
            return Wave(
                power: power,
                curves: (0..<4).map { _ in
                    return Curve.random(withPower: power)
                },
                useCurves: numCurves
            )
        }
    }
    
    var waves: [Wave]
    
    init(numWaves: Int, power: Double) {
        
        waves = [Wave]()
        
        for _ in 0..<numWaves {
            waves.append(.random(withPower: power))
        }
    }
}

//extension SiriWave.Curve: Animatable {
//
//    typealias AnimatableData = AnimatablePair<
//        AnimatablePair<Double, Double>, AnimatablePair<Double, Double>>
//
//    var animatableData: AnimatableData {
//
//        get {
//            .init(.init(A, power), .init(k, t))
//        }
//
//        set {
//            A = newValue.first.first
//            power = newValue.first.second
//            k = newValue.second.first
//            t = newValue.second.second
//        }
//
//    }
//
//}

// This part is temporary because you cannot create an
// array of animatable data

extension VoqaWave.Wave: Animatable {
    
    typealias AnimatableData = AnimatablePair<
        AnimatablePair<
            AnimatablePair<
                AnimatablePair<Double, Double>,
                AnimatablePair<Double, Double>
            >,
            AnimatablePair<
                AnimatablePair<Double, Double>,
                AnimatablePair<Double, Double>
            >
        >,
        AnimatablePair<
            AnimatablePair<
                AnimatablePair<Double, Double>,
                AnimatablePair<Double, Double>
            >,
            AnimatablePair<
                AnimatablePair<Double, Double>,
                AnimatablePair<
                    AnimatablePair<Double, Double>,
                    AnimatablePair<Double, Double>
                >
            >
        >
    >
    
    var animatableData: AnimatableData {
        
        get {
            .init(
                .init(
                    .init(
                        .init(curves[0].A, curves[0].power),
                        .init(curves[0].k, curves[0].t)),
                    .init(
                        .init(curves[1].A, curves[1].power),
                        .init(curves[1].k, curves[1].t))),
                .init(
                    .init(
                        .init(curves[2].A, curves[2].power),
                        .init(curves[2].k, curves[2].t)),
                    .init(
                        .init(curves[3].A, curves[3].power),
                        .init(
                            .init(curves[3].k, curves[3].t),
                            .init(power, .zero)))))
        }
        
        set {
            curves[0].A = newValue.first.first.first.first
            curves[0].power = newValue.first.first.first.second
            curves[0].k = newValue.first.first.second.first
            curves[0].t = newValue.first.first.second.second
            
            curves[1].A = newValue.first.second.first.first
            curves[1].power = newValue.first.second.first.second
            curves[1].k = newValue.first.second.second.first
            curves[1].t = newValue.first.second.second.second
            
            curves[2].A = newValue.second.first.first.first
            curves[2].power = newValue.second.first.first.second
            curves[2].k = newValue.second.first.second.first
            curves[2].t = newValue.second.first.second.second
            
            curves[3].A = newValue.second.second.first.first
            curves[3].power = newValue.second.second.first.second
            curves[3].k = newValue.second.second.second.first.first
            curves[3].t = newValue.second.second.second.first.second
            
            power = newValue.second.second.second.second.first
        }
        
    }
    
}


//struct VoqaWaveViewWithSwitch: View {
//    @Binding var switchOn: Bool
//    @State private var voqaWave: VoqaWave
//    @State private var power: Double = 0.0
//    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.3, on: .main, in: .common)
//    @State private var timerCancellable: Cancellable?
//
//    var colors: [Color]
//    var supportLineColor: Color
//    
//    init(colors: [Color], supportLineColor: Color = .white, switchOn: Binding<Bool>) {
//        self._switchOn = switchOn
//        self._voqaWave = State(initialValue: VoqaWave(numWaves: colors.count, power: 0.0))
//        self.colors = colors
//        self.supportLineColor = supportLineColor
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // Support line at the back
//                SupportLine(color: supportLineColor)
//                
//                // Dynamic wave views for each color
//                ForEach(Array(zip(voqaWave.waves.indices, voqaWave.waves)), id: \.0) { index, wave in
//                    WaveView(wave: wave, color: colors[index % colors.count])
//                        .animation(.linear(duration: 0.2), value: power)
//                }
//            }
//            .blendMode(.lighten)
//            .drawingGroup()
//        }
//        .onAppear {
//            voqaWave = VoqaWave(numWaves: colors.count, power: power)
//            toggleTimerBasedOnSwitch()
//        }
//        .onChange(of: switchOn) { _ in
//            toggleTimerBasedOnSwitch()
//        }
//        .onReceive(timer) { _ in
//            updatePowerRandomly()
//        }
//    }
//    
//    private func toggleTimerBasedOnSwitch() {
//        if switchOn {
//            // Start or continue the timer
//            if timerCancellable == nil {
//                timerCancellable = timer.connect()
//            }
//        } else {
//            // Stop the timer when switch is off
//            timerCancellable?.cancel()
//            timerCancellable = nil
//        }
//    }
//    
//    private func updatePowerRandomly() {
//        withAnimation {
//            power = Double.random(in: 0.0...2.0)
//            voqaWave = VoqaWave(numWaves: colors.count, power: power)
//        }
//    }
//}
