//
//  LaunchPages.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import SwiftUI
import WebKit
import AVFoundation






//
//struct QuizTimeView: View {
//    @State private var audioPlayer: AVAudioPlayer?
//
//    var body: some View {
//        GeometryReader { geometry in
//            WebView(url: URL(string: "https://voqa.io")!)
//                .frame(width: geometry.size.width, height: geometry.size.height)
//                .edgesIgnoringSafeArea(.all)
//        }
//        .onAppear {
//            playAudioAfterDelay()
//        }
//    }
//    
//    private func playAudioAfterDelay() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            playAudio()
//        }
//    }
//    
//    private func playAudio() {
//        if let path = Bundle.main.path(forResource: "Sleeping Dreams", ofType: "mp3") {
//            let url = URL(fileURLWithPath: path)
//            
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: url)
//                audioPlayer?.play()
//            } catch {
//                print("Error playing audio: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//
//
//#Preview {
//    QuizTimeView()
//}
