//
//  MiniPlayerControls.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import SwiftUI

struct MiniPlayerControls: View {
    var recordAction: () -> Void
    var playPauseAction: () -> Void
    var nextAction: () -> Void
    var repeatAction: () -> Void
    
    @State private var tappedPlay: Bool = false
    
    @State private var isUsingMic: Bool = false
    
    let imageSize: CGFloat = 18
    
    var body: some View {
        HStack(spacing: 20) {

            Divider()
                .frame(height: 50)
                .foregroundStyle(.secondary)
            
            Button(action: {
                playPauseAction()
                provideHapticFeedback()
                tappedPlay.toggle()
            }) {
                Image(systemName: "play.fill")
                    .font(.title)
            }
            
            Divider()
                .frame(height: 50)
                .foregroundStyle(.secondary)
            
            
            Button(action: {
                provideHapticFeedback()
               
            }) {
                Image(systemName: "stop.fill")
                    .font(.title)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    MiniPlayerControls(recordAction: {}, playPauseAction: {}, nextAction: {}, repeatAction: {})
}
