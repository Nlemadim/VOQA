//
//  NowPlayingView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/22/24.
//

import SwiftUI
import AVFoundation

struct NowPlayingView: View {
    var nowPlaying: (any AudioQuizProtocol)?
    var generator: ColorGenerator
    var questionCount: Int
    var currentQuestionIndex: Int
    var color: Color
    @ObservedObject var quizContext: QuizContext
    @Binding var isDownloading: Bool
    
    var playAction: () -> Void
    
    var body: some View {
        HStack {
//            VStack(spacing: 4) {
//                Image(nowPlaying?.titleImage ?? "IconImage")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .cornerRadius(10)
//                    .accessibilityLabel(Text(nowPlaying?.quizTitle ?? "Quiz Image"))
//            }
//            .frame(height: 100)
//            .overlay {
//                if isDownloading {
//                    ProgressView {
//                        Text("Downloading")
//                    }
//                    .foregroundStyle(.white)
//                    .accessibilityLabel(Text("Downloading"))
//                }
//            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(nowPlaying?.quizTitle.uppercased() ?? "VOQA")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .accessibilityAddTraits(.isHeader)
                
                HStack(spacing: 12) {
                    Text(quizContext.audioPlayer?.isPlaying == true ? "Playing" : "Paused")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .accessibilityLabel(Text(quizContext.audioPlayer?.isPlaying == true ? "Playing" : "Paused"))
                    
                    Image(systemName: outputDeviceImageName())
                        .foregroundColor(.secondary)
                        .font(.footnote)
                        .accessibilityLabel(Text("Sound output device: \(outputDeviceDescription())"))
                }
                
                Text("Completed Quizzes: \(nowPlaying?.completions ?? 0)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(Text("Completed Quizzes: \(nowPlaying?.completions ?? 0)"))
                
                HStack {
                    VUMeterView(quizContext: quizContext)
                        .hAlign(.trailing)
                    
//                    CircularPlayButton(
//                        quizContext: quizContext,
//                        isDownloading: $isDownloading,
//                        color: generator.dominantBackgroundColor,
//                        playAction: playAction
//                    )
//                    .hAlign(.trailing)
                }
            }
            .padding(.top, 5)
            .frame(width: .infinity)
            .padding(.horizontal, 4)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func outputDeviceImageName() -> String {
        let audioSession = AVAudioSession.sharedInstance()
        switch audioSession.currentRoute.outputs.first?.portType {
        case .headphones:
            return "headphones"
        case .bluetoothA2DP, .bluetoothHFP, .bluetoothLE:
            return "earbuds"
        case .builtInSpeaker:
            return "speaker.wave.2.fill"
        default:
            return "questionmark"
        }
    }
    
    private func outputDeviceDescription() -> String {
        let audioSession = AVAudioSession.sharedInstance()
        switch audioSession.currentRoute.outputs.first?.portType {
        case .headphones:
            return "Headphones"
        case .bluetoothA2DP, .bluetoothHFP, .bluetoothLE:
            return "Bluetooth"
        case .builtInSpeaker:
            return "Built-in Speaker"
        default:
            return "Unknown Device"
        }
    }
}
