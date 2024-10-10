//
//  ListeningSources.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/10/24.
//

import Foundation

enum ListeningSource: Hashable, CaseIterable {
    case headphones(connected: Bool)
    case speakers(connected: Bool)
    case bluetooth(connected: Bool)

    var title: String {
        switch self {
        case .headphones(let connected):
            return connected ? "Headphones (Connected)" : "Headphones (Disconnected)"
        case .speakers(let connected):
            return connected ? "Speakers (Connected)" : "Speakers (Disconnected)"
        case .bluetooth(let connected):
            return connected ? "Bluetooth (Connected)" : "Bluetooth (Disconnected)"
        }
    }

    // Define allCases manually due to associated values
    static var allCases: [ListeningSource] {
        return [
            .headphones(connected: false),
            .speakers(connected: false),
            .bluetooth(connected: false)
        ]
    }

    // Optional: If you need to return a default state for all cases, you can add this
    static func defaultStates() -> [ListeningSource] {
        return allCases // You can just return allCases here
    }
}
