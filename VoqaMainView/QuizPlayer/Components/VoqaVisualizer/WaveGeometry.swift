//
//  WaveGeometry.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
//

import Foundation
import SwiftUI


private struct WaveGeometry {
    
    var wave: VoqaWave.Wave
    var points: [CGPoint]
    var origin: CGPoint
    
    init(_ wave: VoqaWave.Wave, in rect: CGRect) {
        
        self.wave = wave
        self.points = [CGPoint]()
        self.origin = CGPoint(x: 0, y: rect.midY)
        
        let xPoints = Array(stride(from: -rect.midX, to: rect.midX, by: 1.0))
        
        var coordinates = [[Double]](repeating: [0.0, 0.0], count: xPoints.count)
        
        for i in 0..<self.wave.useCurves {
            
            let A = self.wave.curves[i].A * Double(rect.midY) * self.wave.power
            
            var j = 0
            
            for graphX in xPoints {
                
                let graphScaledX = graphX / (rect.midX / 9.0)
                
                let x = rect.midX + graphX
                let y = self.attn(x: Double(graphScaledX), A: A, k: self.wave.curves[i].k, t: self.wave.curves[i].t) + Double(self.origin.y)
                
                coordinates[j] = [Double(x), max(coordinates[j][1], y)]
                
                j += 1
                
            }
            
        }
        
        // Create inverse points
        coordinates += coordinates.map({ (coord) -> [Double] in
            return [coord[0], ((coord[1] - Double(rect.midY)) * -1) + Double(rect.midY)]
        })
        
        for coord in coordinates {
            self.points.append(CGPoint(x: coord[0], y: coord[1]))
        }
        
    }
    
    private func sine(x: Double, A: Double, k: Double, t: Double) -> Double {

        return A * sin((k * x) - t)

    }

    private func g(x: Double, t: Double, K: Double, k: Double) -> Double {

        return pow(K / (K + pow((k * x) - t, 2)), K)

    }

    private func attn(x: Double, A: Double, k: Double, t: Double) -> Double {

        return abs(sine(x: x, A: A, k: k, t: t) * g(x: x, t: t - (Double.pi / 2), K: 4, k: k))

    }
    
}

struct WaveShape: Shape {
    
    var wave: VoqaWave.Wave
    
    func path(in rect: CGRect) -> Path {
        
        let geometry = WaveGeometry(wave, in: rect)
        var path = Path()
        
        path.move(to: geometry.origin)
        path.addLines(geometry.points)
        
        return path
        
    }
    
    var animatableData: VoqaWave.Wave.AnimatableData {
        
        get {
            return wave.animatableData
        }
        
        set {
            wave.animatableData = newValue
        }

    }
    
}

struct WaveView: View {
    
    var wave: VoqaWave.Wave
    var color: Color
    
    var body: some View {
        
        WaveShape(wave: wave)
            .fill(color)
        
    }
}


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
