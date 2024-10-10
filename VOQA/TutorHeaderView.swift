//
//  TutorHeaderView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/10/24.
//

import SwiftUI


struct TutorHeaderView: View {
    @State var themeColors: [Color] = [.purple, .teal]
    @State var quizSession: QuizSession?
    let tutorImage = "Amina"
    let themeImage = "Thinking Math"
    
    var body: some View {
        ZStack {
            VoqaWaveViewWithSwitch(switchOn: quizSession?.isNowPlaying ?? false, colors: themeColors, supportLineColor: .white)
                .frame(height: 45)
                
            HStack {
                Image(tutorImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100) // Ensure height matches width for a circle
                    .clipShape(Circle()) // Clip the image in a circular shape
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .padding()
                Spacer()
            }
        }
    }
}


#Preview {
    TutorHeaderView()
        .preferredColorScheme(.dark)
}
