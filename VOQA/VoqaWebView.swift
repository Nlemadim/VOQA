//
//  VoqaWebView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/18/24.
//

import SwiftUI
import WebKit
import AVFoundation

struct VoqaWebView: View {
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        GeometryReader { geometry in
            WebView(url: URL(string: "https://voqa.io")!)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            playAudioAfterDelay()
        }
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
    }
    
    private func playAudioAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            playAudio()
        }
    }
    
    private func playAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        if let path = Bundle.main.path(forResource: "Sleeping Dreams", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            
            do {
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
                
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
//#Preview {
//    //VoqaWebView()
//}
