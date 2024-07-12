//
//  VoqaWave.swift
//  VOQA
//
//  Created by Tony Nlemadim on 7/12/24.
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

