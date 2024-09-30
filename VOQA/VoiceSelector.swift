//
//  VoiceSelector.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/12/24.
//

import Foundation

enum VoiceSelector: String {
    case gus = "Gus"
    case erin = "Erin"
    case ini = "Ini"
    case dogonYaro = "Dogon Yaro"
    
    // Property to return the voice designation for each case
    var voiceDesignation: String {
        switch self {
        case .gus:
            return "Brian"
        case .erin:
            return "Charlotte"
        case .ini:
            return "Patrick"
        case .dogonYaro:
            return "Grandpa Spuds Oxley"
        }
    }
}

