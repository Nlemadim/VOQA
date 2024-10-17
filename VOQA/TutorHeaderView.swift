//
//  TutorHeaderView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 10/10/24.
//

import SwiftUI


struct TutorHeaderView: View {
    @Binding var isNowSpeaking: Bool
    @State var themeColors: [Color]
    let tutorImage = "Amina"
    let themeImage = "Thinking Math"
    
    var body: some View {
        ZStack {
//            VoqaWaveViewWithSwitch(switchOn: $isNowSpeaking, colors: themeColors, supportLineColor: .white)
//                .frame(height: 45)
                
            HStack {
                Image(tutorImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80) // Ensure height matches width for a circle
                    .clipShape(Circle()) // Clip the image in a circular shape
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .padding()
                Spacer()
            }
        }
    }
}


#Preview {
    TutorHeaderView(isNowSpeaking: .constant(false), themeColors: [.purple, .teal])
        .preferredColorScheme(.dark)
}

#Preview {
    QuizHeaderView(voqa: mockItems[0], secondaryInfo: "Question 23/46")
        .preferredColorScheme(.dark)
}



struct QuizHeaderView: View {
    let voqa: VoqaItem
    @State var secondaryInfo: String
    var body: some View {
        ZStack {
            SupportLine(color: Color.fromHex(voqa.colors.main))
                .activeGlow(.white, radius: 0.8)
               
            HStack(alignment: .center, spacing: 16) {
                // Image for the voqaItem
                CachedImageView(imageUrl: voqa.imageUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(2)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Material.ultraThin)
                            
                    )
                
                VStack(alignment: .leading) {
                    // Title for the voqaItem
                    Text(voqa.quizTitle)
                        .font(.callout)
                        .bold()
                        .padding(.horizontal, 5)
                    Divider()
                    Text(secondaryInfo)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(5)
                  
                        
                }
            }
        }
        .padding()
        
    }
}
