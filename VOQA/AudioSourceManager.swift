//
//  AudioSourceManager.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/10/24.
//

import Foundation
import SwiftUI
import Combine

class AudioSourceViewModel: ObservableObject {
    @Published var listeningSources: [ListeningSource] = []
    
    init() {
        // Initialize with default states
        updateAudioSources()
    }
    
    func updateAudioSources() {
        // Mock detection logic for demonstration purposes
        listeningSources = [
            .headphones(connected: true),
            .speakers(connected: false),
            .bluetooth(connected: true)
        ]
    }
    
    func toggleHeadphones() {
        if let index = listeningSources.firstIndex(where: { if case .headphones = $0 { return true } else { return false }}) {
            if case let .headphones(connected) = listeningSources[index] {
                listeningSources[index] = .headphones(connected: !connected)
            }
        }
    }

    func toggleSpeakers() {
        if let index = listeningSources.firstIndex(where: { if case .speakers = $0 { return true } else { return false }}) {
            if case let .speakers(connected) = listeningSources[index] {
                listeningSources[index] = .speakers(connected: !connected)
            }
        }
    }

    func toggleBluetooth() {
        if let index = listeningSources.firstIndex(where: { if case .bluetooth = $0 { return true } else { return false }}) {
            if case let .bluetooth(connected) = listeningSources[index] {
                listeningSources[index] = .bluetooth(connected: !connected)
            }
        }
    }
}
