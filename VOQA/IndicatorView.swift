//
//  IndicatorView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/10/24.
//

import Foundation
import SwiftUI

struct IndicatorView: View {
    @ObservedObject var viewModel: AudioSourceViewModel

    var body: some View {
        HStack(spacing: 16) {
            ForEach(viewModel.listeningSources, id: \.self) { source in
                VStack {
                    Image(systemName: iconName(for: source))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(isConnected(for: source) ? .green : .red)
                        .onTapGesture {
                            handleTap(for: source)
                        }
                    Text(source.title)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
    }
    
    private func iconName(for source: ListeningSource) -> String {
        switch source {
        case .headphones:
            return "headphones"
        case .speakers:
            return "speaker.3"
        case .bluetooth:
            return "bluetooth"
        }
    }
    
    private func isConnected(for source: ListeningSource) -> Bool {
        switch source {
        case .headphones(let connected):
            return connected
        case .speakers(let connected):
            return connected
        case .bluetooth(let connected):
            return connected
        }
    }
    
    private func handleTap(for source: ListeningSource) {
        // Handle tapping logic here, for example, toggling connection state
        switch source {
        case .headphones:
            viewModel.toggleHeadphones()
        case .speakers:
            viewModel.toggleSpeakers()
        case .bluetooth:
            viewModel.toggleBluetooth()
        }
    }
}
